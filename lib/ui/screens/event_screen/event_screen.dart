import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/ui/screens/crew_qr_screen/crew_qr_screen.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  final Competition competition;

  const EventScreen({Key? key, required this.event, required this.competition}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (widget.competition.type == 'REGULAR_DRIVE') {
      return _regularDrive();
    } else {
      //  classic
    }

    return Container();
  }

  // Widget _classic() {}

  Widget _regularDrive() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
        title: Padding(
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
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('resources/reg_background.jpg'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Choose your position",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 0.2 * height),
                  child: FlatButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      splashColor: Colors.blueAccent,
                      padding: EdgeInsets.all(30),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CrewQrScreen(
                                    event: widget.event,
                                    competition: widget.competition,
                                  )),
                        );
                      },
                      child: const Text(
                        "START",
                        style: TextStyle(fontSize: 20.0),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0.2 * height),
                  child: FlatButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      splashColor: Colors.blueAccent,
                      padding: const EdgeInsets.all(30),
                      onPressed: () {
                        //TODO
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RegScreenEnd(widget.competition, widget.additionalInfoCompetition)));
                      },
                      child: const Text(
                        "END",
                        style: TextStyle(fontSize: 20.0),
                      )),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0.03 * height),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Average speed: " + (widget.competition.averageSpeed!).toString() + " km/h",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ),
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Description: " + widget.competition.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
