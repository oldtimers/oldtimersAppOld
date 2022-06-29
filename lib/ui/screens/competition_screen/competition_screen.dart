import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/ui/screens/crew_qr_screen/crew_qr_screen.dart';
import 'package:oldtimers_rally_app/ui/screens/score_screen/reg_end_screen.dart';

import '../../../model/competition_field.dart';

class CompetitionScreen extends StatefulWidget {
  final Event event;
  final Competition competition;
  final List<CompetitionField> competitionFields;

  const CompetitionScreen({Key? key, required this.event, required this.competition, required this.competitionFields}) : super(key: key);

  @override
  _CompetitionScreenState createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  // @override
  // Future<void> initState() async {
  //   if (widget.competition.type == CompetitionType.REGULAR_DRIVE) {
  //     compFields = [];
  //   } else {
  //     compFields = await (await MyDatabase.getInstance()).competitionFieldDao.findCompetitionFieldsByCompetition(widget.competition.id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (widget.competition.type == CompetitionType.REGULAR_DRIVE) {
      return _regularDrive();
    } else {
      return _classic();
    }
  }

  Widget _classic() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Widget> fields = [];
    for (var i = 0; i < widget.competitionFields.length; i++) {
      fields.add(Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            widget.competitionFields[i].label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        color: Colors.black,
      ));
      if (i < widget.competitionFields.length - 1) {
        fields.add(SizedBox(
          height: height * 0.01,
        ));
      }
    }
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
          width: width,
          height: height,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('resources/time_background.jpg'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Info",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0.01 * height),
                  child: Column(
                    children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Nazwa: " + (widget.competition.name).toString(),
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
                                "Opis: " + widget.competition.description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 20.0, color: Colors.white),
                              ),
                            ),
                            color: Colors.black,
                          ),
                        ] +
                        (widget.competition.possibleInvalid
                            ? [
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Możliwość spalenia próby",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                                    ),
                                  ),
                                  color: Colors.black,
                                )
                              ]
                            : []),
                  ),
                ),
                const Text(
                  "Pola",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0.01 * height),
                  child: Column(
                    children: fields,
                  ),
                ),
                FlatButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    padding: const EdgeInsets.all(30),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CrewQrScreen(competition: widget.competition, event: widget.event)));
                    },
                    child: const Text(
                      "Skanuj kod QR",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ],
            ),
          )),
    );
  }

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
              "Wybierz swoją pozycję",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegEndScreen(competition: widget.competition, event: widget.event)));
                      },
                      child: const Text(
                        "KONIEC",
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
                        "Średnia prędkość: " + (widget.competition.averageSpeed!).toString() + " km/h",
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
                        "Opis: " + widget.competition.description,
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
