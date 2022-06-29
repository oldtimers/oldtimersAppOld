import 'dart:convert';

import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/const.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/competition_field.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/my_database.dart';
import 'package:oldtimers_rally_app/utils/server_connector.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tuple/tuple.dart';

import '../model/result.dart';

class DataRepository {
  static Future<List<Event>> getEvents(AuthenticationBloc authBloc) async {
    var response = await ServerConnector.makeRequest(kEvents, authBloc, requestType.GET);
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Event> events = List<Event>.from(l.map((model) => Event.fromJson(model)));
    return events;
  }

  static Future<Tuple2<List<Competition>, List<CompetitionField>>> getCompetitions(Event event, AuthenticationBloc authBloc) async {
    var response = await ServerConnector.makeRequest(sprintf(kCompetitions, [event.id]), authBloc, requestType.GET);
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Competition> competitions = List<Competition>.from(l.map((model) => Competition.fromJson(model)));
    List<CompetitionField> competitionFields = [];
    for (var row in l) {
      for (var field in row['fields']) {
        competitionFields.add(CompetitionField.fromJson(field));
      }
    }
    return Tuple2(competitions, competitionFields);
  }

  static Future<Crew?> getCrew(String qr, Event event, AuthenticationBloc authBloc) async {
    var response =
        await ServerConnector.makeRequest(sprintf(kCrew, [event.id]), authBloc, requestType.POST, statusCode: {200, 400}, body: jsonEncode({"qr": qr}));
    if (response.statusCode == 200) {
      return Crew.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  static setResultOnRegStart(DateTime time, int crewID, int competitionID, int eventId, AuthenticationBloc authBloc) async {
    var body = jsonEncode(<String, dynamic>{'position': 'START', 'crewId': crewID, 'competitionId': competitionID, 'time': time.millisecondsSinceEpoch});
    Result result = await MyDatabase.saveResult(Result(null, eventId, MyDatabase.retrieveAuthentication(authBloc).userId, body.toString(), 1));
    tryToSendRequest(sprintf(kScoreReg, [eventId]), authBloc, requestType.POST, body, result);
  }

  static setResult(Competition competition, Crew crew, Event event, Map<String, dynamic> body, AuthenticationBloc authBloc) async {
    Map<String, dynamic> tempBody = {"crewId": crew.id, "competitionId": competition.id};
    tempBody.addAll(body);
    Result result = await MyDatabase.saveResult(Result(null, event.id, MyDatabase.retrieveAuthentication(authBloc).userId, jsonEncode(tempBody).toString(), 0));
    tryToSendRequest(sprintf(kScore, [event.id]), authBloc, requestType.POST, jsonEncode(tempBody), result);
  }

  static getCrewsInRegCompetition(AuthenticationBloc authBloc, int eventId, int competitionId) async {
    var response = await ServerConnector.makeRequest(sprintf(kCrewsInCompetition, [eventId, competitionId]), authBloc, requestType.GET);
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Crew> crews = List<Crew>.from(l.map((model) => Crew.fromJson(model)));
    return crews;
  }

  static setResultOnRegEnd(DateTime time, int crewID, int competitionID, int eventId, AuthenticationBloc authBloc) async {
    var body = jsonEncode(<String, dynamic>{'position': 'END', 'crewId': crewID, 'competitionId': competitionID, 'time': time.millisecondsSinceEpoch});
    Result result = await MyDatabase.saveResult(Result(null, eventId, MyDatabase.retrieveAuthentication(authBloc).userId, body.toString(), 1));
    tryToSendRequest(sprintf(kScoreReg, [eventId]), authBloc, requestType.POST, body, result);
  }

  static Future<void> tryToSendRequest(String uri, AuthenticationBloc authBloc, requestType type, String body, Result result) async {
    try {
      var response = await ServerConnector.makeRequest(uri, authBloc, type, body: body);
      await MyDatabase.deleteResult(result);
    } on Exception catch (_) {}
  }

  static Future<List<Competition>> synchronizeEvent(Event event, AuthenticationBloc authBloc) async {
    var d1 = await getCompetitions(event, authBloc);
    await MyDatabase.synchronizeCompetitions(d1.item1, d1.item2, event);
    var d2 = await getCrews(event, authBloc);
    await MyDatabase.synchronizeCrews(d2, event);
    List<Result> results0 = await MyDatabase.getResults(event, authBloc, 0);
    var chunks0 = splitToChunks(results0);
    for (List<Result> chunk in chunks0) {
      var res = chunk.map((e) => jsonDecode(e.body)).toList();
      var response = await ServerConnector.makeRequest(sprintf(kScores, [event.id]), authBloc, requestType.POST, body: jsonEncode(res));
      await MyDatabase.deleteResults(chunk);
    }
    List<Result> results1 = await MyDatabase.getResults(event, authBloc, 1);
    var chunks1 = splitToChunks(results1);
    for (List<Result> chunk in chunks1) {
      var res = chunk.map((e) => jsonDecode(e.body)).toList();
      var response = await ServerConnector.makeRequest(sprintf(kScoreRegs, [event.id]), authBloc, requestType.POST, body: jsonEncode(res));
      await MyDatabase.deleteResults(chunk);
    }
    return d1.item1;
  }

  // static sendResults(List<Result> results, AuthenticationBloc authBloc) async {
  //   Map<String, dynamic> tempBody = {"crewId": crew.id, "competitionId": competition.id};
  //   tempBody.addAll(body);
  //   Result result = await MyDatabase.saveResult(Result(null, event.id, MyDatabase.retrieveAuthentication(authBloc).userId, jsonEncode(tempBody).toString()));
  //   tryToSendRequest(sprintf(kScore, [event.id]), authBloc, requestType.POST, jsonEncode(tempBody), result);
  // }

  static List<List<Result>> splitToChunks(List<Result> results) {
    var len = results.length;
    var size = 40;
    List<List<Result>> chunks = [];

    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      chunks.add(results.sublist(i, end));
    }
    return chunks;
  }

  static Future<List<Crew>> getCrews(Event event, AuthenticationBloc authBloc) async {
    var response =
        await ServerConnector.makeRequest(sprintf(kCrews, [event.id]), authBloc, requestType.POST, statusCode: {200}, body: jsonEncode({"eventId": event.id}));
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Crew> crews = List<Crew>.from(l.map((model) => Crew.fromJson(model)));
    return crews;
  }
}
