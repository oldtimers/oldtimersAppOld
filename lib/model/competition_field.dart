import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oldtimers_rally_app/converters/field_type_converter.dart';
import 'package:oldtimers_rally_app/model/competition.dart';

part 'competition_field.g.dart';

@JsonSerializable()
@TypeConverters([FieldTypeConverter])
@Entity(foreignKeys: [
  ForeignKey(childColumns: ['competitionId'], parentColumns: ['id'], entity: Competition, onDelete: ForeignKeyAction.cascade)
])
class CompetitionField {
  @primaryKey
  final int id;
  final int competitionId;
  final FieldType type;
  @ColumnInfo(name: 'order_f')
  final int order;
  final String label;

  CompetitionField(this.id, this.competitionId, this.type, this.order, this.label);

  factory CompetitionField.fromJson(Map<String, dynamic> json) => _$CompetitionFieldFromJson(json);
}

enum FieldType { FLOAT, INT, BOOLEAN, TIMER, DATETIME }
