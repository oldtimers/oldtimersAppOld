import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';
import 'package:oldtimers_rally_app/utils/my_database.dart';

import '../competitions_screen/competitions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthenticationBloc authBloc;
  late List<Event> events;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (isLoaded) {
      List<Widget> eventWidgets = [];
      for (Event event in events) {
        eventWidgets.add(Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 0.05 * height),
            child: FlatButton(
                color: Colors.black,
                textColor: Colors.white,
                splashColor: Colors.blueAccent,
                padding: const EdgeInsets.all(30),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompetitionsScreen(
                                event: event,
                              )));
                },
                child: Text(
                  event.name,
                  style: const TextStyle(fontSize: 20.0),
                )),
          ),
        ));
      }

      return MaterialApp(
        home: Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        _downloadEventsList();
                      },
                      child: const Text('POBIERZ')),
                  const Text('Rajdy'),
                  TextButton(
                      onPressed: () async {
                        authBloc.add(LoggedOut());
                      },
                      style: TextButton.styleFrom(primary: Colors.red),
                      child: const Text('Wyloguj się')),
                ],
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('resources/background_main_photo.jpg'), fit: BoxFit.cover)),
            width: width,
            height: height,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(15.0),
              scrollDirection: Axis.vertical,
              children: eventWidgets,
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _getEvents();
    super.initState();
  }

  void _getEvents() async {
    var temp = await MyDatabase.getListOfEvent(authBloc);
    setState(() {
      events = temp;
      isLoaded = true;
    });
  }

  void _downloadEventsList() async {
    setState(() {
      isLoaded = false;
    });
    List<Event> temp = [];
    try {
      temp = await DataRepository.getEvents(authBloc);
      await MyDatabase.saveListOfEvents(temp, authBloc);
    } on Exception catch (_) {
      temp = events;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Brak Internetu, odświeżanie listy nie powiodło się')));
    } finally {
      setState(() {
        events = temp;
        isLoaded = true;
      });
    }
  }
}
