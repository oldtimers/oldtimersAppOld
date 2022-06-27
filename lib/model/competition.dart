import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oldtimers_rally_app/converters/competition_type_converter.dart';
import 'package:oldtimers_rally_app/model/event.dart';

part 'competition.g.dart';

@JsonSerializable()
@TypeConverters([CompetitionTypeConverter])
@Entity(foreignKeys: [
  ForeignKey(childColumns: ['eventId'], parentColumns: ['id'], entity: Event, onDelete: ForeignKeyAction.cascade)
])
class Competition {
  @primaryKey
  final int id;
  final int eventId;
  final String name;
  final String description;
  final CompetitionType type;
  final double? averageSpeed;

  // final List<CompetitionField> fields;
  final bool possibleInvalid;

  Competition(this.id, this.eventId, this.name, this.description, this.type, this.averageSpeed, this.possibleInvalid);

  factory Competition.fromJson(Map<String, dynamic> json) {
    var res = _$CompetitionFromJson(json);
    // res.fields.sort((a, b) => a.order.compareTo(b.order));
    return res;
  }
}

enum CompetitionType { REGULAR_DRIVE, BEST_MIN, BEST_MAX, COUNTED }
