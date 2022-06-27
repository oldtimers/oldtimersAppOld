// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Authentication _$AuthenticationFromJson(Map<String, dynamic> json) =>
    Authentication(
      json['access'] as String,
      json['refresh'] as String,
      DateTime.parse(json['expirationDate'] as String),
      json['username'] as String,
      json['userId'] as int,
    );

Map<String, dynamic> _$AuthenticationToJson(Authentication instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
      'expirationDate': instance.expirationDate.toIso8601String(),
      'username': instance.username,
      'userId': instance.userId,
    };
