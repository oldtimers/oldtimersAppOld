import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@dao
@Entity(indices: [
  Index(value: ['userId', 'eventId'])
])
@JsonSerializable()
class Result {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int eventId;
  final int userId;
  final String body;
  final int type;

  Result(this.id, this.eventId, this.userId, this.body, this.type);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
