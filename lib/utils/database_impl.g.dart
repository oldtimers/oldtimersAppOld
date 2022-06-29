// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_impl.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) => _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() => _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null ? await sqfliteDatabaseFactory.getDatabasePath(name!) : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  UserEventDao? _userEventDaoInstance;

  EventDao? _eventDaoInstance;

  CompetitionDao? _competitionDaoInstance;

  CompetitionFieldDao? _competitionFieldDaoInstance;

  CrewDao? _crewDaoInstance;

  ResultDao? _resultDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations, [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute('CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserEvent` (`userId` INTEGER NOT NULL, `eventId` INTEGER NOT NULL, FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`userId`, `eventId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Event` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `url` TEXT NOT NULL, `stage` TEXT NOT NULL, `mainPhoto` TEXT, `startDate` INTEGER, `endDate` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Competition` (`id` INTEGER NOT NULL, `eventId` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `type` TEXT NOT NULL, `averageSpeed` REAL, `possibleInvalid` INTEGER NOT NULL, FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CompetitionField` (`id` INTEGER NOT NULL, `competitionId` INTEGER NOT NULL, `type` TEXT NOT NULL, `order_f` INTEGER NOT NULL, `label` TEXT NOT NULL, FOREIGN KEY (`competitionId`) REFERENCES `Competition` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Crew` (`id` INTEGER NOT NULL, `number` INTEGER NOT NULL, `yearOfProduction` INTEGER NOT NULL, `phone` TEXT NOT NULL, `car` TEXT NOT NULL, `driverName` TEXT NOT NULL, `qr` TEXT NOT NULL, `eventId` INTEGER NOT NULL, FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Result` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `eventId` INTEGER NOT NULL, `userId` INTEGER NOT NULL, `body` TEXT NOT NULL, `type` INTEGER NOT NULL)');
        await database.execute('CREATE UNIQUE INDEX `index_Crew_qr` ON `Crew` (`qr`)');
        await database.execute('CREATE INDEX `index_Result_userId_eventId` ON `Result` (`userId`, `eventId`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  UserEventDao get userEventDao {
    return _userEventDaoInstance ??= _$UserEventDao(database, changeListener);
  }

  @override
  EventDao get eventDao {
    return _eventDaoInstance ??= _$EventDao(database, changeListener);
  }

  @override
  CompetitionDao get competitionDao {
    return _competitionDaoInstance ??= _$CompetitionDao(database, changeListener);
  }

  @override
  CompetitionFieldDao get competitionFieldDao {
    return _competitionFieldDaoInstance ??= _$CompetitionFieldDao(database, changeListener);
  }

  @override
  CrewDao get crewDao {
    return _crewDaoInstance ??= _$CrewDao(database, changeListener);
  }

  @override
  ResultDao get resultDao {
    return _resultDaoInstance ??= _$ResultDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(database, 'User', (User item) => <String, Object?>{'id': item.id, 'name': item.name}),
        _userUpdateAdapter = UpdateAdapter(database, 'User', ['id'], (User item) => <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  @override
  Future<User?> findUserById(int id) async {
    return _queryAdapter
        .query('select * from User where id =?1', mapper: (Map<String, Object?> row) => User(row['id'] as int, row['name'] as String), arguments: [id]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }
}

class _$UserEventDao extends UserEventDao {
  _$UserEventDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userEventInsertionAdapter =
            InsertionAdapter(database, 'UserEvent', (UserEvent item) => <String, Object?>{'userId': item.userId, 'eventId': item.eventId}),
        _userEventDeletionAdapter = DeletionAdapter(
            database, 'UserEvent', ['userId', 'eventId'], (UserEvent item) => <String, Object?>{'userId': item.userId, 'eventId': item.eventId});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserEvent> _userEventInsertionAdapter;

  final DeletionAdapter<UserEvent> _userEventDeletionAdapter;

  @override
  Future<List<UserEvent>> findAllByUser(int userId) async {
    return _queryAdapter.queryList('select * from UserEvent where userId = ?1',
        mapper: (Map<String, Object?> row) => UserEvent(row['userId'] as int, row['eventId'] as int), arguments: [userId]);
  }

  @override
  Future<void> insertUserEvents(List<UserEvent> userEvents) async {
    await _userEventInsertionAdapter.insertList(userEvents, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertUserEvent(UserEvent userEvent) async {
    await _userEventInsertionAdapter.insert(userEvent, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUserEvents(List<UserEvent> userEvents) async {
    await _userEventDeletionAdapter.deleteList(userEvents);
  }
}

class _$EventDao extends EventDao {
  _$EventDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _eventInsertionAdapter = InsertionAdapter(
            database,
            'Event',
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'url': item.url,
                  'stage': item.stage,
                  'mainPhoto': item.mainPhoto,
                  'startDate': _dateTimeConverter.encode(item.startDate),
                  'endDate': _dateTimeConverter.encode(item.endDate)
                }),
        _eventUpdateAdapter = UpdateAdapter(
            database,
            'Event',
            ['id'],
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'url': item.url,
                  'stage': item.stage,
                  'mainPhoto': item.mainPhoto,
                  'startDate': _dateTimeConverter.encode(item.startDate),
                  'endDate': _dateTimeConverter.encode(item.endDate)
                }),
        _eventDeletionAdapter = DeletionAdapter(
            database,
            'Event',
            ['id'],
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'url': item.url,
                  'stage': item.stage,
                  'mainPhoto': item.mainPhoto,
                  'startDate': _dateTimeConverter.encode(item.startDate),
                  'endDate': _dateTimeConverter.encode(item.endDate)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Event> _eventInsertionAdapter;

  final UpdateAdapter<Event> _eventUpdateAdapter;

  final DeletionAdapter<Event> _eventDeletionAdapter;

  @override
  Future<Event?> findById(int id) async {
    return _queryAdapter.query('select * from Event where id = ?1',
        mapper: (Map<String, Object?> row) => Event(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String,
            row['url'] as String,
            row['stage'] as String,
            row['mainPhoto'] as String?,
            _dateTimeConverter.decode(row['startDate'] as int?),
            _dateTimeConverter.decode(row['endDate'] as int?)),
        arguments: [id]);
  }

  @override
  Future<List<Event>> findByUserId(int userId) async {
    return _queryAdapter.queryList('select e.* from Event e inner join UserEvent u on e.id = u.eventId where u.userId = ?1',
        mapper: (Map<String, Object?> row) => Event(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String,
            row['url'] as String,
            row['stage'] as String,
            row['mainPhoto'] as String?,
            _dateTimeConverter.decode(row['startDate'] as int?),
            _dateTimeConverter.decode(row['endDate'] as int?)),
        arguments: [userId]);
  }

  @override
  Future<void> insertEvent(Event event) async {
    await _eventInsertionAdapter.insert(event, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEvent(Event event) async {
    await _eventUpdateAdapter.update(event, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEvent(Event event) async {
    await _eventDeletionAdapter.delete(event);
  }
}

class _$CompetitionDao extends CompetitionDao {
  _$CompetitionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _competitionInsertionAdapter = InsertionAdapter(
            database,
            'Competition',
            (Competition item) => <String, Object?>{
                  'id': item.id,
                  'eventId': item.eventId,
                  'name': item.name,
                  'description': item.description,
                  'type': _competitionTypeConverter.encode(item.type),
                  'averageSpeed': item.averageSpeed,
                  'possibleInvalid': item.possibleInvalid ? 1 : 0
                }),
        _competitionDeletionAdapter = DeletionAdapter(
            database,
            'Competition',
            ['id'],
            (Competition item) => <String, Object?>{
                  'id': item.id,
                  'eventId': item.eventId,
                  'name': item.name,
                  'description': item.description,
                  'type': _competitionTypeConverter.encode(item.type),
                  'averageSpeed': item.averageSpeed,
                  'possibleInvalid': item.possibleInvalid ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Competition> _competitionInsertionAdapter;

  final DeletionAdapter<Competition> _competitionDeletionAdapter;

  @override
  Future<List<Competition>> findCompetitionsByEvent(int eventId) async {
    return _queryAdapter.queryList('select * from Competition where eventId = ?1 order by id',
        mapper: (Map<String, Object?> row) => Competition(row['id'] as int, row['eventId'] as int, row['name'] as String, row['description'] as String,
            _competitionTypeConverter.decode(row['type'] as String), row['averageSpeed'] as double?, (row['possibleInvalid'] as int) != 0),
        arguments: [eventId]);
  }

  @override
  Future<void> insertCompetitions(List<Competition> competitions) async {
    await _competitionInsertionAdapter.insertList(competitions, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCompetitions(List<Competition> competitions) async {
    await _competitionDeletionAdapter.deleteList(competitions);
  }
}

class _$CompetitionFieldDao extends CompetitionFieldDao {
  _$CompetitionFieldDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _competitionFieldInsertionAdapter = InsertionAdapter(
            database,
            'CompetitionField',
            (CompetitionField item) => <String, Object?>{
                  'id': item.id,
                  'competitionId': item.competitionId,
                  'type': _fieldTypeConverter.encode(item.type),
                  'order_f': item.order,
                  'label': item.label
                }),
        _competitionFieldDeletionAdapter = DeletionAdapter(
            database,
            'CompetitionField',
            ['id'],
            (CompetitionField item) => <String, Object?>{
                  'id': item.id,
                  'competitionId': item.competitionId,
                  'type': _fieldTypeConverter.encode(item.type),
                  'order_f': item.order,
                  'label': item.label
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CompetitionField> _competitionFieldInsertionAdapter;

  final DeletionAdapter<CompetitionField> _competitionFieldDeletionAdapter;

  @override
  Future<List<CompetitionField>> findCompetitionFieldsByCompetition(int competitionId) async {
    return _queryAdapter.queryList('select * from CompetitionField where competitionId = ?1 order by order_f',
        mapper: (Map<String, Object?> row) => CompetitionField(
            row['id'] as int, row['competitionId'] as int, _fieldTypeConverter.decode(row['type'] as String), row['order_f'] as int, row['label'] as String),
        arguments: [competitionId]);
  }

  @override
  Future<void> insertCompetitionFields(List<CompetitionField> competitionFields) async {
    await _competitionFieldInsertionAdapter.insertList(competitionFields, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCompetitionFields(List<CompetitionField> competitionFields) async {
    await _competitionFieldDeletionAdapter.deleteList(competitionFields);
  }
}

class _$CrewDao extends CrewDao {
  _$CrewDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _crewInsertionAdapter = InsertionAdapter(
            database,
            'Crew',
            (Crew item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'yearOfProduction': item.yearOfProduction,
                  'phone': item.phone,
                  'car': item.car,
                  'driverName': item.driverName,
                  'qr': item.qr,
                  'eventId': item.eventId
                }),
        _crewDeletionAdapter = DeletionAdapter(
            database,
            'Crew',
            ['id'],
            (Crew item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'yearOfProduction': item.yearOfProduction,
                  'phone': item.phone,
                  'car': item.car,
                  'driverName': item.driverName,
                  'qr': item.qr,
                  'eventId': item.eventId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Crew> _crewInsertionAdapter;

  final DeletionAdapter<Crew> _crewDeletionAdapter;

  @override
  Future<List<Crew>> findCrewsByEvent(int eventId) async {
    return _queryAdapter.queryList('select * from Crew where eventId = ?1 order by number',
        mapper: (Map<String, Object?> row) => Crew(row['id'] as int, row['number'] as int, row['yearOfProduction'] as int, row['phone'] as String,
            row['car'] as String, row['driverName'] as String, row['qr'] as String, row['eventId'] as int),
        arguments: [eventId]);
  }

  @override
  Future<Crew?> findCrewByQr(String qr, int eventId) async {
    return _queryAdapter.query('select * from Crew where qr = ?1 and eventId = ?2',
        mapper: (Map<String, Object?> row) => Crew(row['id'] as int, row['number'] as int, row['yearOfProduction'] as int, row['phone'] as String,
            row['car'] as String, row['driverName'] as String, row['qr'] as String, row['eventId'] as int),
        arguments: [qr, eventId]);
  }

  @override
  Future<void> insertCrews(List<Crew> crews) async {
    await _crewInsertionAdapter.insertList(crews, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCrews(List<Crew> crews) async {
    await _crewDeletionAdapter.deleteList(crews);
  }
}

class _$ResultDao extends ResultDao {
  _$ResultDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _resultInsertionAdapter = InsertionAdapter(database, 'Result',
            (Result item) => <String, Object?>{'id': item.id, 'eventId': item.eventId, 'userId': item.userId, 'body': item.body, 'type': item.type}),
        _resultDeletionAdapter = DeletionAdapter(database, 'Result', ['id'],
            (Result item) => <String, Object?>{'id': item.id, 'eventId': item.eventId, 'userId': item.userId, 'body': item.body, 'type': item.type});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Result> _resultInsertionAdapter;

  final DeletionAdapter<Result> _resultDeletionAdapter;

  @override
  Future<List<Result>> findByEventAndUser(int eventId, int userId, int type) async {
    return _queryAdapter.queryList('select * from Result where eventId = ?1 and userId = ?2 and type = ?3',
        mapper: (Map<String, Object?> row) => Result(row['id'] as int?, row['eventId'] as int, row['userId'] as int, row['body'] as String, row['type'] as int),
        arguments: [eventId, userId, type]);
  }

  @override
  Future<Result?> findById(int id) async {
    return _queryAdapter.query('select * from Result where id = ?1',
        mapper: (Map<String, Object?> row) => Result(row['id'] as int?, row['eventId'] as int, row['userId'] as int, row['body'] as String, row['type'] as int),
        arguments: [id]);
  }

  @override
  Future<int> insertResult(Result result) {
    return _resultInsertionAdapter.insertAndReturnId(result, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteResult(Result result) async {
    await _resultDeletionAdapter.delete(result);
  }

  @override
  Future<void> deleteResults(List<Result> results) async {
    await _resultDeletionAdapter.deleteList(results);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _competitionTypeConverter = CompetitionTypeConverter();
final _fieldTypeConverter = FieldTypeConverter();
