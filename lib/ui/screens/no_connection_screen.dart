import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('resources/404_photo.jpg'))),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("No connection with server",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.red),
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.only(bottom: 0.1 * height),
                  child: FlatButton(
                    color: Colors.black,
                    textColor: Colors.red,
                    splashColor: Colors.blueAccent,
                    padding: EdgeInsets.all(30),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(AppStarted());
                    },
                    child: const Text(
                      "Connect again",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
