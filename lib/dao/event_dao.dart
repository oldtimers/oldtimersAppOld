import 'package:floor/floor.dart';

import '../model/event.dart';

@dao
abstract class EventDao {
  @Query('select * from Event where id = :id')
  Future<Event?> findById(int id);

  @Query('select e.* from Event e inner join UserEvent u on e.id = u.eventId where u.userId = :userId')
  Future<List<Event>> findByUserId(int userId);

  @insert
  Future<void> insertEvent(Event event);

  @update
  Future<void> updateEvent(Event event);

  @delete
  Future<void> deleteEvent(Event event);

  @transaction
  Future<void> saveListOfEvents(List<Event> events) async {
    for (var value in events) {
      if ((await findById(value.id)) == null) {
        await insertEvent(value);
      } else {
        await updateEvent(value);
      }
    }
  }
}
