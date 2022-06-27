import 'package:floor/floor.dart';

@dao
@Entity(indices: [
  Index(value: ['userId', 'eventId'])
])
class Result {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int eventId;
  final int userId;
  final String body;

  Result(this.id, this.eventId, this.userId, this.body);
}
