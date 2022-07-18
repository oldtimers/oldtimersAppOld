import 'dart:collection';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/competition_field.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';
import 'package:tuple/tuple.dart';

import '../../../utils/my_database.dart';
import '../competition_screen/competition_screen.dart';

class CompetitionsScreen extends StatefulWidget {
  final Event event;

  const CompetitionsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _CompetitionsScreenState createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  static final RegExp _regExp = RegExp(r"^[a-zA-Z]*");
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  late AuthenticationBloc authBloc;
  late List<Tuple2<String, List<Competition>>> groups;
  bool isLoaded = false;
  bool toSynchronize = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        key: scaffold,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 100,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              'resources/OLDTIMERS-WEB LOGO.png',
              fit: BoxFit.contain,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    style: (toSynchronize ? TextButton.styleFrom(primary: Colors.red) : TextButton.styleFrom(primary: Colors.green)),
                    onPressed: () async {
                      _synchronizeEvent(widget.event);
                    },
                    child: const Text('SYNCHRONIZUJ')),
                const Text('Konkurencje'),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: isLoaded
            ? Accordion(
                maxOpenSections: 1,
                children: groups
                    .map((group) => AccordionSection(
                          isOpen: false,
                          content: Column(
                              children: group.item2
                                  .map(
                                    (competition) => Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 0.05 * height),
                                        child: FlatButton(
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            splashColor: Colors.blueAccent,
                                            padding: const EdgeInsets.all(30),
                                            onPressed: () async {
                                              List<CompetitionField> fields = await MyDatabase.getCompetitionFields(competition);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => CompetitionScreen(
                                                            event: widget.event,
                                                            competition: competition,
                                                            competitionFields: fields,
                                                          )));
                                            },
                                            child: Text(
                                              competition.name,
                                              style: const TextStyle(fontSize: 20.0),
                                            )),
                                      ),
                                    ),
                                  )
                                  .toList()),
                          header: Text(
                            group.item1,
                            style: const TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                          headerBackgroundColor: Colors.black,
                          headerBackgroundColorOpened: Colors.black,
                          contentBorderColor: Colors.black,
                        ))
                    .toList())
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loadFromDb(widget.event);
    super.initState();
  }

  void _loadFromDb(Event event) async {
    var temp = await MyDatabase.getCompetitions(event, authBloc);
    var results = await MyDatabase.getResults(event, authBloc, 0) + await MyDatabase.getResults(event, authBloc, 1);
    var grouped = _groupList(temp);
    setState(() {
      groups = grouped;
      isLoaded = true;
      toSynchronize = results.isNotEmpty;
    });
  }

  List<Tuple2<String, List<Competition>>> _groupList(List<Competition> competitions) {
    SplayTreeMap<String, List<Competition>> mapCompetition = SplayTreeMap<String, List<Competition>>();
    for (var competition in competitions) {
      var name = _regExp.firstMatch(competition.name)!.group(0).toString();
      if (mapCompetition.containsKey(name)) {
        mapCompetition[name]!.add(competition);
      } else {
        mapCompetition[name] = [competition];
      }
    }
    return mapCompetition.entries.map((e) => Tuple2(e.key, e.value)).toList();
  }

  void _synchronizeEvent(Event event) async {
    setState(() {
      isLoaded = false;
    });
    try {
      await DataRepository.synchronizeEvent(event, authBloc);
      if (scaffold.currentState != null) {
        scaffold.currentState!.showSnackBar(const SnackBar(content: Text('Pomyślnie dokonano synchronizacji')));
      }
    } on Exception catch (_) {
      if (scaffold.currentState != null) {
        scaffold.currentState!.showSnackBar(const SnackBar(content: Text('Brak Internetu, synchronizacja nie powiodła się')));
      }
    } finally {
      _loadFromDb(event);
    }
  }
}
