import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginController;
  TextEditingController passwordController;
  List<Widget> additionalChildren = [];
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    var state = BlocProvider.of<AuthenticationBloc>(context).state;
    if (state is AuthenticationInvalidCredentials) {
      loginController.text = state.login;
      additionalChildren.add(const Text("Invalid login or password"));
    }
    super.initState();
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text('Logging'),
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
            children: additionalChildren +
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: loginController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Login',
                          hintText: 'Type login'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter password'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.05 * height),
                    child: FlatButton(
                        color: Colors.black,
                        textColor: Colors.white,
                        splashColor: Colors.blueAccent,
                        padding: const EdgeInsets.all(30),
                        onPressed: () async {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                              LoggingIn(
                                  login: loginController.value.text,
                                  password: passwordController.value.text));
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 20.0),
                        )),
                  ),
                ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    loginController.dispose();
    super.dispose();
  }
}
