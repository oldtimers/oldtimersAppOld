import 'package:equatable/equatable.dart';
import 'package:oldtimers_rally_app/model/event.dart';

abstract class EventState extends Equatable {
  @override
  List<Object> get props => [];

  get event => null;
}

class EventListUnknown extends EventState {}

class EventListShown extends EventState {
  final List<Event> events;

  EventListShown(this.events);
}

class EventSelected extends EventState {
  @override
  final Event event;

  EventSelected(this.event);
}
