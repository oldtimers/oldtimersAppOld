import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/bloc/authentication_bloc.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/ui/screens/crew_qr_screen/crew_qr_screen.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';

class RegStart extends StatefulWidget {
  final Crew crew;
  final Competition competition;
  final Event event;

  const RegStart({Key? key, required this.crew, required this.competition, required this.event}) : super(key: key);

  @override
  _RegStartState createState() => _RegStartState();
}

class _RegStartState extends State<RegStart> {
  late AuthenticationBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
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
              children: [
                Text(
                  "Crew: " + widget.crew.number.toString(),
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.competition.name,
                  style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('resources/reg_background.jpg'), fit: BoxFit.cover)),
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Start crew by pressing a button",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0.2 * height),
              child: FlatButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  splashColor: Colors.blueAccent,
                  padding: const EdgeInsets.all(30),
                  onPressed: () async {
                    DateTime time = DateTime.now().toUtc();
                    await DataRepository.setResultOnRegStart(time, widget.crew.id, widget.competition.id, widget.event.id, authBloc);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CrewQrScreen(
                                  event: widget.event,
                                  competition: widget.competition,
                                )));
                  },
                  child: const Text(
                    "START",
                    style: TextStyle(fontSize: 20.0),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
