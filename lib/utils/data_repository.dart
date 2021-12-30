import 'dart:convert';

import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/const.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/server_connector.dart';
import 'package:sprintf/sprintf.dart';

class DataRepository {
  static Future<List<Event>> getEvents(AuthenticationBloc authBloc) async {
    var response = await ServerConnector.makeRequest(kEvents, authBloc, requestType.GET);
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Event> events = List<Event>.from(l.map((model) => Event.fromJson(model)));
    return events;
  }

  static Future<List<Competition>> getCompetitions(Event event, AuthenticationBloc authBloc) async {
    var response = await ServerConnector.makeRequest(sprintf(kCompetitions, [event.id]), authBloc, requestType.GET);
    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    List<Competition> competitions = List<Competition>.from(l.map((model) => Competition.fromJson(model)));
    return competitions;
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
    List<Crew> events = List<Crew>.from(l.map((model) => Crew.fromJson(model)));
    return events;
  }

  static setResultOnRegEnd(DateTime time, int crewID, int competitionID, int eventId, AuthenticationBloc authBloc) async {
    var body = jsonEncode(<String, dynamic>{'position': 'END', 'crewId': crewID, 'competitionId': competitionID, 'time': time.millisecondsSinceEpoch});
    var response = await ServerConnector.makeRequest(sprintf(kScoreReg, [eventId]), authBloc, requestType.POST, body: body);
  }
}
