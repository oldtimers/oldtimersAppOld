import 'package:json_annotation/json_annotation.dart';

part 'competition_field.g.dart';

@JsonSerializable()
class CompetitionField {
  final int id;
  final FieldType type;
  final int order;
  final String label;

  CompetitionField(this.id, this.type, this.order, this.label);

  factory CompetitionField.fromJson(Map<String, dynamic> json) => _$CompetitionFieldFromJson(json);
}

enum FieldType { FLOAT, INT, BOOLEAN, TIMER }
