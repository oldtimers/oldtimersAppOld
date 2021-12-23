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
    );

Map<String, dynamic> _$CompetitionToJson(Competition instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'averageSpeed': instance.averageSpeed,
    };
