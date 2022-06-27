import 'package:json_annotation/json_annotation.dart';

part 'authentication.g.dart';

@JsonSerializable()
class Authentication {
  final String access;
  final String refresh;
  final DateTime expirationDate;
  final String username;
  final int userId;

  Authentication(this.access, this.refresh, this.expirationDate, this.username, this.userId);

  Map<String, dynamic> toJson() => _$AuthenticationToJson(this);

  factory Authentication.fromJson(Map<String, dynamic> json) => _$AuthenticationFromJson(json);
}
