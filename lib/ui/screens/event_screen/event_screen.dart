import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState(event);
}

class _EventScreenState extends State<EventScreen> {
  final Event event;
  late AuthenticationBloc authBloc;
  late List<Event> competitions;
  bool isLoaded = false;

  _EventScreenState(this.event);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _getCompetitions(event);
    super.initState();
  }

  void _getCompetitions(Event event) async {
    var temp = await DataRepository.getCompetitions(event, authBloc);
    setState(() {
      competitions = temp;
      isLoaded = true;
    });
  }
}
