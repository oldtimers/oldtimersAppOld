import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/authentication.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/model/user.dart';
import 'package:oldtimers_rally_app/model/user_event.dart';

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
    if ((await db.userDao.findUserById(auth.userId)) == null) {
      db.userDao.insertUser(User(auth.userId, auth.username));
    } else {
      db.userDao.updateUser(User(auth.userId, auth.username));
    }
  }

  @transaction
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
}
