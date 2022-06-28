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
  }

  static setResultOnRegStart(DateTime time, int crewID, int competitionID, int eventId, AuthenticationBloc authBloc) async {
    var body = jsonEncode(<String, dynamic>{'position': 'START', 'crewId': crewID, 'competitionId': competitionID, 'time': time.millisecondsSinceEpoch});
    var response = await ServerConnector.makeRequest(sprintf(kScoreReg, [eventId]), authBloc, requestType.POST, body: body);
  }

  static setResult(Competition competition, Crew crew, Event event, Map<String, dynamic> body, AuthenticationBloc authBloc) async {
    Map<String, dynamic> tempBody = {"crewId": crew.id, "competitionId": competition.id};
    tempBody.addAll(body);
    var response = await ServerConnector.makeRequest(sprintf(kScore, [event.id]), authBloc, requestType.POST, body: jsonEncode(tempBody));
  }

  static getCrewsInRegCompetition(AuthenticationBloc authBloc, int eventId, int competitionId) async {
    var response = await ServerConnector.makeRequest(sprintf(kCrewsInCompetition, [eventId, competitionId]), authBloc, requestType.GET);
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Crew> crews = List<Crew>.from(l.map((model) => Crew.fromJson(model)));
    return crews;
  }

  static setResultOnRegEnd(DateTime time, int crewID, int competitionID, int eventId, AuthenticationBloc authBloc) async {
    var body = jsonEncode(<String, dynamic>{'position': 'END', 'crewId': crewID, 'competitionId': competitionID, 'time': time.millisecondsSinceEpoch});
    var response = await ServerConnector.makeRequest(sprintf(kScoreReg, [eventId]), authBloc, requestType.POST, body: body);
  }

  static Future<List<Competition>> synchronizeEvent(Event event, AuthenticationBloc authBloc) async {
    var d1 = await getCompetitions(event, authBloc);
    await MyDatabase.synchronizeCompetitions(d1.item1, d1.item2, event);
    var d2 = await getCrews(event, authBloc);
    await MyDatabase.synchronizeCrews(d2, event);
    return d1.item1;
  }

  static Future<List<Crew>> getCrews(Event event, AuthenticationBloc authBloc) async {
    var response =
        await ServerConnector.makeRequest(sprintf(kCrews, [event.id]), authBloc, requestType.POST, statusCode: {200}, body: jsonEncode({"eventId": event.id}));
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Crew> crews = List<Crew>.from(l.map((model) => Crew.fromJson(model)));
    return crews;
  }
}
