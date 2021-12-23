import 'dart:convert';

import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/const.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/server_connector.dart';

class DataRepository {
  static Future<List<Event>> getEvents(AuthenticationBloc authBloc) async {
    var response = await ServerConnector.makeRequest(kEvents, authBloc, requestType.GET);
    Iterable l = json.decode(response.body);
    List<Event> events = List<Event>.from(l.map((model) => Event.fromJson(model)));
    return events;
  }

  static Future<List<Event>> getCompetitions(Event event, AuthenticationBloc authBloc) {
    return [];
  }
}
