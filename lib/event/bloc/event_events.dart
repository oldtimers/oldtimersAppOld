import 'package:equatable/equatable.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/event.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventEvent {
  final AuthenticationBloc authBloc;

  const LoadEvents(this.authBloc);
}

class SelectedEvent extends EventEvent {
  final Event event;

  const SelectedEvent(this.event);

  @override
  List<Object> get props => [event];
}

class ChangeLanguage extends EventEvent {
  final String lang;
  final AuthenticationBloc authBloc;
  final Event? event;

  const ChangeLanguage(this.lang, this.authBloc, this.event);
  @override
  List<Object> get props => [lang];
}
