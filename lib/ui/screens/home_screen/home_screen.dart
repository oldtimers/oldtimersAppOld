import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationBloc authBloc;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return isLoaded
        ? Scaffold(
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
                    Text('Rallies'),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('resources/home_screen_background.jpg'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _getEvents();
    super.initState();
  }

  void _getEvents() async {
    // var temp = await DataRepository.getUserEvents(authBloc);
    setState(() {
      // po = temp;
      isLoaded = true;
    });
  }
}
