import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/user_event.dart';

@dao
abstract class UserEventDao {
  @Query('select * from UserEvent where userId = :userId')
  Future<List<UserEvent>> findAllByUser(int userId);

  @insert
  Future<void> insertUserEvents(List<UserEvent> userEvents);

  @insert
  Future<void> insertUserEvent(UserEvent userEvent);

  @delete
  Future<void> deleteUserEvents(List<UserEvent> userEvents);
}
