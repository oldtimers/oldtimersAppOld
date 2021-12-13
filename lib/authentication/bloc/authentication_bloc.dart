import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/utils/user_repository.dart';
import 'package:tuple/tuple.dart';

import 'authentication_events.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthenticationState initialState) : super(initialState);

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        final String token = await UserRepository.getTokenAndVerify();
        if (token != null) {
          yield AuthenticationAuthenticated(authToken: token);
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (error) {
        print(error);

        yield AuthenticationNotPossible();
      }
    }
    if (event is LoggingIn) {
      yield AuthenticationLoading();
      try {
        Tuple2 r = await UserRepository.login(
            login: event.login, password: event.password);
        if (r.item1 != null) {
          yield AuthenticationAuthenticated(authToken: r.item2);
        } else {
          yield AuthenticationInvalidCredentials(event.login);
        }
      } catch (e) {
        yield AuthenticationNotPossible();
      }
    }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await UserRepository.persistTokenAndRefresh(
          Tuple2(event.refresh, event.token));
      yield AuthenticationAuthenticated(authToken: event.token);
    }
    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await UserRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
    if (event is TokenRenewed) {
      yield AuthenticationAuthenticated(authToken: event.token);
    }
    if (event is LostAuthentication) {
      yield AuthenticationUnauthenticated();
    }
    if (event is AuthenticationError) {
      yield AuthenticationNotPossible();
    }
  }
}
