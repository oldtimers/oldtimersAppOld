// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Crew _$CrewFromJson(Map<String, dynamic> json) => Crew(
      json['id'] as int,
      json['number'] as int,
      json['yearOfProduction'] as int,
      json['phone'] as String,
      json['car'] as String,
      json['driverName'] as String,
      json['qr'] as String,
      json['eventId'] as String,
    );

Map<String, dynamic> _$CrewToJson(Crew instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'yearOfProduction': instance.yearOfProduction,
      'phone': instance.phone,
      'car': instance.car,
      'driverName': instance.driverName,
      'qr': instance.qr,
      'eventId': instance.eventId,
    };
