// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetitionField _$CompetitionFieldFromJson(Map<String, dynamic> json) =>
    CompetitionField(
      json['id'] as int,
      json['competitionId'] as int,
      $enumDecode(_$FieldTypeEnumMap, json['type']),
      json['order'] as int,
      json['label'] as String,
    );

Map<String, dynamic> _$CompetitionFieldToJson(CompetitionField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competitionId': instance.competitionId,
      'type': _$FieldTypeEnumMap[instance.type]!,
      'order': instance.order,
      'label': instance.label,
    };

const _$FieldTypeEnumMap = {
  FieldType.FLOAT: 'FLOAT',
  FieldType.INT: 'INT',
  FieldType.BOOLEAN: 'BOOLEAN',
  FieldType.TIMER: 'TIMER',
  FieldType.DATETIME: 'DATETIME',
};
