import 'dart:async';

import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/dao/competition_dao.dart';
import 'package:oldtimers_rally_app/dao/event_dao.dart';
import 'package:oldtimers_rally_app/dao/result_dao.dart';
import 'package:oldtimers_rally_app/dao/user_dao.dart';
import 'package:oldtimers_rally_app/dao/user_event_dao.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/competition_field.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/model/user.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../converters/competition_type_converter.dart';
import '../converters/date_time_converter.dart';
import '../converters/field_type_converter.dart';
import '../dao/competition_field_dao.dart';
import '../dao/crew_dao.dart';
import '../model/result.dart';
import '../model/user_event.dart';

part 'database_impl.g.dart';

@Database(version: 1, entities: [User, UserEvent, Event, Competition, CompetitionField, Crew, Result])
abstract class FlutterDatabase extends FloorDatabase {
  UserDao get userDao;

  UserEventDao get userEventDao;

  EventDao get eventDao;

  CompetitionDao get competitionDao;

  CompetitionFieldDao get competitionFieldDao;

  CrewDao get crewDao;

  ResultDao get resultDao;
}
