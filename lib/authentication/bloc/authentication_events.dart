import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationError extends AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggingIn extends AuthenticationEvent {
  final String login;
  final String password;

  const LoggingIn({@required this.login, @required this.password});
  @override
  List<Object> get props => [login, password];

  @override
  String toString() => 'Logging { email: $login }';
}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String refresh;

  const LoggedIn({@required this.token, @required this.refresh});

  @override
  List<Object> get props => [token, refresh];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class TokenRenewed extends AuthenticationEvent {
  final String token;

  TokenRenewed({@required this.token});

  @override
  String toString() => 'Token Renewed { token: $token }';
  @override
  List<Object> get props => [token];
}

class LostAuthentication extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}
