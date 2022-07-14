import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../manual_crew_dialog.dart';

class RegEndScreen extends StatefulWidget {
  final Competition competition;
  final Event event;

  const RegEndScreen({Key? key, required this.competition, required this.event}) : super(key: key);

  @override
  _RegEndScreenState createState() => _RegEndScreenState();
}

class _RegEndScreenState extends State<RegEndScreen> {
  late AuthenticationBloc authBloc;
  late Timer timer;
  List<Crew> crewsInCompetition = [];
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> updateCrews() async {
    var info = 'Dokonano synchronizacji';
    try {
      List<dynamic> temp = await DataRepository.getCrewsInRegCompetition(authBloc, widget.event.id, widget.competition.id);
      List<Crew> temp2 = [];
      for (var object in temp) {
        if (object.runtimeType == Crew) {
          temp2.add(object);
        }
      }
      setState(() {
        crewsInCompetition = temp2;
      });
    } on Exception catch (_) {
      info = 'Brak Internetu';
    }
    if (scaffold.currentState != null) {
      scaffold.currentState!.showSnackBar(SnackBar(content: Text(info)));
    }
    _refreshController.refreshCompleted();
  }

  void showInputPopup() async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          myF(Crew crew) => {showPopup(crew)};
          return ManualCrewDialog(authBloc, myF, widget.event);
        });
  }

  void showPopup(Crew crew) async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          var timestamp = DateTime.now().toUtc();
          return ConfirmDialog(crew, timestamp, widget.competition, authBloc, updateCrews, widget.event);
        });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    updateCrews();
    addTask();
    super.initState();
  }

  void addTask() {
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => updateCrews());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      key: scaffold,
      resizeToAvoidBottomInset: false,
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    style: TextButton.styleFrom(primary: Colors.green),
                    onPressed: () async {
                      showInputPopup();
                    },
                    child: const Text('WPISZ RĘCZNIE')),
                Text(
                  widget.competition.name,
                  style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
        // decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('resources/reg_background.jpg'), fit: BoxFit.cover)),
        child: SmartRefresher(
          header: WaterDropHeader(),
          onRefresh: () => updateCrews(),
          controller: _refreshController,
          child: crewsInCompetition.isNotEmpty
              ? ListView.separated(
                  itemCount: crewsInCompetition.length,
                  itemBuilder: (BuildContext context, int index) {
                    Crew crew = crewsInCompetition[index];
                    return InkWell(
                      hoverColor: Colors.red,
                      focusColor: Colors.green,
                      splashColor: Colors.blue,
                      highlightColor: Colors.grey,
                      child: CrewTile(crew),
                      onTap: () => showPopup(crew),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.black,
                      height: 1,
                    );
                  },
                  controller: null,
                )
              : Center(
                  child: Container(
                      color: Colors.black,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Brak wystartowanych załóg",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      )),
                ),
        ),
      ),
    );
  }
}

class CrewTile extends StatelessWidget {
  final Crew crew;

  CrewTile(this.crew);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("Numer załogi: " + crew.number.toString() + " Kierowca: " + crew.driverName),
          ],
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  final Crew crew;
  final DateTime timestamp;
  final Competition competition;
  final AuthenticationBloc authBloc;
  final Function actionOnEnd;
  final Event event;

  const ConfirmDialog(this.crew, this.timestamp, this.competition, this.authBloc, this.actionOnEnd, this.event);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  void sendData() async {
    setState(() {
      loading = true;
    });
    await DataRepository.setResultOnRegEnd(widget.timestamp, widget.crew.id, widget.competition.id, widget.event.id, widget.authBloc);
    widget.actionOnEnd();
    Navigator.of(context).pop();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return !loading
        ? AlertDialog(
            title: Text(
              "Zatrzymać załogę " + widget.crew.number.toString() + "?",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            actions: [
              RaisedButton(
                onPressed: sendData,
                child: const Text("Tak"),
              ),
              RaisedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Nie"),
              )
            ],
            content: Text(
              "Końcowy czas: " + widget.timestamp.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
