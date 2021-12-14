// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Authentication _$AuthenticationFromJson(Map<String, dynamic> json) =>
    Authentication(
      json['access'] as String,
      json['refresh'] as String,
      json['username'] as String,
    );

Map<String, dynamic> _$AuthenticationToJson(Authentication instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
      'username': instance.username,
    };
