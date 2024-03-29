// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['url'] as String,
      json['stage'] as String,
      json['mainPhoto'] as String?,
      json['startDate'] == null ? null : DateTime.parse(json['startDate'] as String),
      json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
      'stage': instance.stage,
      'mainPhoto': instance.mainPhoto,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
