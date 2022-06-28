import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/authentication.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/model/user.dart';
import 'package:oldtimers_rally_app/model/user_event.dart';

import '../model/competition_field.dart';
import 'database_impl.dart';

class MyDatabase {
  static Future<FlutterDatabase>? _singleton;

  static Future<FlutterDatabase> getInstance() {
    _singleton ??= $FloorFlutterDatabase.databaseBuilder('oldtimers_rally.db').build();
    return _singleton!;
  }

  static Authentication _retrieveAuthentication(AuthenticationBloc authBloc) {
    return (authBloc.state as AuthenticationAuthenticated).authentication;
  }

  static Future<List<Event>> getListOfEvent(AuthenticationBloc authBloc) async {
    var auth = _retrieveAuthentication(authBloc);
    return await (await getInstance()).eventDao.findByUserId(auth.userId);
  }

  static Future<void> saveUser(Authentication auth) async {
    var db = await getInstance();
    var x = await db.userDao.findUserById(auth.userId);
    if (x == null) {
      db.userDao.insertUser(User(auth.userId, auth.username));
    } else {
      db.userDao.updateUser(User(auth.userId, auth.username));
    }
  }

  static Future<void> saveListOfEvents(List<Event> temp, AuthenticationBloc authBloc) async {
    var db = await getInstance();
    var auth = _retrieveAuthentication(authBloc);
    var old = await db.userEventDao.findAllByUser(auth.userId);
    await db.userEventDao.deleteUserEvents(old);
    List<UserEvent> userEvents = [];
    for (var value in temp) {
      if ((await db.eventDao.findById(value.id)) == null) {
        await db.eventDao.insertEvent(value);
      } else {
        await db.eventDao.updateEvent(value);
      }
      userEvents.add(UserEvent(auth.userId, value.id));
    }
    await db.userEventDao.insertUserEvents(userEvents);
  }

  static Future<List<Competition>> getCompetitions(Event event, AuthenticationBloc authBloc) async {
    var db = await getInstance();
    return db.competitionDao.findCompetitionsByEvent(event.id);
  }

  static Future<void> synchronizeCompetitions(List<Competition> competitions, List<CompetitionField> competitionFields, Event event) async {
    var db = await getInstance();
    var old = await db.competitionDao.findCompetitionsByEvent(event.id);
    await db.competitionDao.deleteCompetitions(old);
    await db.competitionDao.insertCompetitions(competitions);
    await db.competitionFieldDao.insertCompetitionFields(competitionFields);
  }

  static Future<void> synchronizeCrews(List<Crew> crews, Event event) async {
    var db = await getInstance();
    var old = await db.crewDao.findCrewsByEvent(event.id);
    await db.crewDao.deleteCrews(old);
    await db.crewDao.insertCrews(crews);
  }

  static Future<List<CompetitionField>> getCompetitionFields(Competition competition) async {
    var db = await getInstance();
    return db.competitionFieldDao.findCompetitionFieldsByCompetition(competition.id);
  }

  static Future<Crew?> getCrew(String qr, Event event) async {
    var db = await getInstance();
    return db.crewDao.findCrewByQr(qr, event.id);
  }
}
