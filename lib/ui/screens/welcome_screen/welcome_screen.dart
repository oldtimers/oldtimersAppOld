import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatelessWidget {
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
              children: const [
                Text('LOGOWANIE'),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('resources/background_main_photo2.jpg'),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "ABY ZALOGOWAĆ SIĘ JAKO SĘDZIA ZESKANUJ SĘDZIOWSKI KOD QR",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.2 * height),
                child: FlatButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    padding: EdgeInsets.all(30),
                    onPressed: () async {
                      // await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => LoginQRScreen()),
                      // );
                    },
                    child: const Text(
                      "SKANUJ KOD QR",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
