// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Competition _$CompetitionFromJson(Map<String, dynamic> json) => Competition(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['type'] as String,
      (json['averageSpeed'] as num?)?.toDouble(),
      (json['fields'] as List<dynamic>)
          .map((e) => CompetitionField.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['possibleInvalid'] as bool,
    );

Map<String, dynamic> _$CompetitionToJson(Competition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'averageSpeed': instance.averageSpeed,
      'fields': instance.fields,
      'possibleInvalid': instance.possibleInvalid,
    };
