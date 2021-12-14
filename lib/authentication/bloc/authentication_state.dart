import 'package:equatable/equatable.dart';
import 'package:oldtimers_rally_app/model/authentication.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];

  get token => null;
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  Authentication authentication;

  AuthenticationAuthenticated({required this.authentication});
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationNotPossible extends AuthenticationState {}

class AuthenticationInvalidCredentials extends AuthenticationState {
  final String login;

  AuthenticationInvalidCredentials(this.login);
}
