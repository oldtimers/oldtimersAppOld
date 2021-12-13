import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];

  get token => null;
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String authToken;

  AuthenticationAuthenticated({@required this.authToken});
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationNotPossible extends AuthenticationState {}

class AuthenticationInvalidCredentials extends AuthenticationState {
  final String login;

  AuthenticationInvalidCredentials(this.login);
}
