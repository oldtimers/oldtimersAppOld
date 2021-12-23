import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/event/bloc/event_events.dart';
import 'package:oldtimers_rally_app/event/bloc/event_state.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc(EventState initialState) : super(initialState);

  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {
    if (event is LoadEvents) {
      yield EventListUnknown();
      final List<Event> events = await DataRepository.getEvents(event.authBloc);
      yield EventListShown(events);
    }
    if (event is SelectedEvent) {
      yield EventSelected(event.event);
    }
    if (event is ChangeLanguage) {
      if (event.event == null) {
        yield EventListUnknown();
        final List<Event> events = await DataRepository.getEvents(event.authBloc);
        yield EventListShown(events);
      } else {}
      // yield Event event = await DataRepository.getEvents(authBloc);
    }
  }
}
