import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/ui/screens/home_screen/home_screen.dart';
import 'package:oldtimers_rally_app/ui/screens/no_connection_screen.dart';
import 'package:oldtimers_rally_app/ui/screens/splash_screen.dart';
import 'package:oldtimers_rally_app/ui/screens/welcome_screen/login_screen.dart';

import 'authentication/authentication.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(AuthenticationUninitialized())..add(AppStarted());
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          if (authState is AuthenticationUninitialized) {
            return SplashScreen();
          }
          if (authState is AuthenticationAuthenticated) {
            return HomeScreen();
          }
          if (authState is AuthenticationUnauthenticated || authState is AuthenticationInvalidCredentials) {
            return LoginScreen();
          }
          if (authState is AuthenticationNotPossible) {
            return NoConnectionScreen();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onCreate(BlocBase bloc) {
    print(bloc);
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    print(bloc);
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print(change);
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event);
  }
}
