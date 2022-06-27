// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Competition _$CompetitionFromJson(Map<String, dynamic> json) => Competition(
      json['id'] as int,
      json['eventId'] as int,
      json['name'] as String,
      json['description'] as String,
      $enumDecode(_$CompetitionTypeEnumMap, json['type']),
      (json['averageSpeed'] as num?)?.toDouble(),
      json['possibleInvalid'] as bool,
    );

Map<String, dynamic> _$CompetitionToJson(Competition instance) => <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'name': instance.name,
      'description': instance.description,
      'type': _$CompetitionTypeEnumMap[instance.type],
      'averageSpeed': instance.averageSpeed,
      'possibleInvalid': instance.possibleInvalid,
    };

const _$CompetitionTypeEnumMap = {
  CompetitionType.REGULAR_DRIVE: 'REGULAR_DRIVE',
  CompetitionType.BEST_MIN: 'BEST_MIN',
  CompetitionType.BEST_MAX: 'BEST_MAX',
  CompetitionType.COUNTED: 'COUNTED',
};
