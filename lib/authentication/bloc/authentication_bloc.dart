import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/model/authentication.dart';
import 'package:oldtimers_rally_app/utils/my_database.dart';
import 'package:oldtimers_rally_app/utils/user_repository.dart';

import 'authentication_events.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthenticationState initialState) : super(initialState);

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        final Authentication? authentication = await UserRepository.retrieveAuthentication();
        if (authentication != null) {
          yield AuthenticationAuthenticated(authentication: authentication);
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (error) {
        yield AuthenticationNotPossible();
      }
    }
    if (event is LoggingIn) {
      yield AuthenticationLoading();
      try {
        Authentication? r = await UserRepository.login(login: event.login, password: event.password);
        if (r != null) {
          await UserRepository.persistAuthentication(r);
          await MyDatabase.saveUser(r);
          yield AuthenticationAuthenticated(authentication: r);
        } else {
          yield AuthenticationInvalidCredentials(event.login);
        }
      } catch (e) {
        yield AuthenticationNotPossible();
      }
    }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await UserRepository.persistAuthentication(event.authentication);
      yield AuthenticationAuthenticated(authentication: event.authentication);
    }
    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await UserRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
    if (event is TokenRenewed) {
      yield AuthenticationAuthenticated(authentication: event.renewed);
    }
    if (event is LostAuthentication) {
      yield AuthenticationUnauthenticated();
    }
    if (event is AuthenticationError) {
      yield AuthenticationNotPossible();
    }
  }
}
