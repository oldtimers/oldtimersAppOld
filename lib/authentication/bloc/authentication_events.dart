import 'package:equatable/equatable.dart';
import 'package:oldtimers_rally_app/model/authentication.dart';

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

  const LoggingIn({required this.login, required this.password});
  @override
  List<Object> get props => [login, password];

  @override
  String toString() => 'Logging { email: $login }';
}

class LoggedIn extends AuthenticationEvent {
  final Authentication authentication;

  const LoggedIn(this.authentication);

  @override
  List<Object> get props => [authentication];

  @override
  String toString() => 'LoggedIn { user: ${authentication.username} }';
}

class TokenRenewed extends AuthenticationEvent {
  final Authentication renewed;

  const TokenRenewed({required this.renewed});

  @override
  String toString() => 'Token Renewed { token: $renewed }';
  @override
  List<Object> get props => [renewed];
}

class LostAuthentication extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}
