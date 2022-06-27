import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/model/user.dart';

@Entity(primaryKeys: [
  'userId',
  'eventId'
], foreignKeys: [
  ForeignKey(childColumns: ["userId"], parentColumns: ['id'], entity: User, onDelete: ForeignKeyAction.cascade),
  ForeignKey(childColumns: ["eventId"], parentColumns: ['id'], entity: Event, onDelete: ForeignKeyAction.cascade),
])
class UserEvent {
  final int userId;
  final int eventId;

  UserEvent(this.userId, this.eventId);
}
