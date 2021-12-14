import 'package:json_annotation/json_annotation.dart';

part 'authentication.g.dart';

@JsonSerializable()
class Authentication {
  final String access;
  final String refresh;
  final String username;

  factory Authentication.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationFromJson(json);

  Authentication(this.access, this.refresh, this.username);
}
