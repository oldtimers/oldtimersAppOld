import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oldtimers_rally_app/authentication/bloc/authentication_bloc.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/ui/screens/score_screen/custom_screen.dart';
import 'package:oldtimers_rally_app/ui/screens/score_screen/reg_start_screen.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CrewQrScreen extends StatefulWidget {
  final Event event;
  final Competition competition;

  const CrewQrScreen({Key? key, required this.event, required this.competition}) : super(key: key);

  @override
  _CrewQrScreenState createState() => _CrewQrScreenState();
}

class _CrewQrScreenState extends State<CrewQrScreen> {
  late QRViewController controller;
  bool torchOn = false;
  bool backCamera = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  late AuthenticationBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  void switchTorch() {
    setState(() {
      torchOn = !torchOn;
    });
    controller.toggleFlash();
  }

  void switchCamera() {
    setState(() {
      backCamera = !backCamera;
    });
    controller.flipCamera();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      key: scaffold,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 20,
              borderLength: 50,
              borderWidth: 10,
              cutOutSize: 400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                width: 100,
                height: 100,
                child: RaisedButton(
                  color: Color(0x30000000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90), side: BorderSide(color: Colors.white)),
                  onPressed: switchTorch,
                  child: Icon(
                    Icons.flash_on,
                    size: 70,
                    color: torchOn ? Colors.yellow : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: SizedBox(
                width: 100,
                height: 100,
                child: RaisedButton(
                  color: const Color(0x30000000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90), side: const BorderSide(color: Colors.white)),
                  onPressed: switchCamera,
                  child: Icon(
                    backCamera ? Icons.camera_enhance : Icons.camera_front,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      if (scaffold.currentState != null) {
        scaffold.currentState!.showSnackBar(const SnackBar(content: Text("Checking QR code")));
      }
      if (scanData.code != null) {
        Crew? crew = await DataRepository.getCrew(scanData.code!, widget.event, authBloc);
        if (crew != null) {
          Route route;
          if (widget.competition.type == 'REGULAR_DRIVE') {
            route = MaterialPageRoute(
                builder: (context) => RegStartScreen(
                      event: widget.event,
                      competition: widget.competition,
                      crew: crew,
                    ));
          } else {
            route = MaterialPageRoute(
                builder: (context) => CustomScreen(
                      event: widget.event,
                      competition: widget.competition,
                      crew: crew,
                    ));
          }
          Navigator.pushReplacement(context, route);
        } else {
          if (scaffold.currentState != null) {
            scaffold.currentState!.showSnackBar(const SnackBar(content: Text("Invalid QR code")));
          }
          controller.resumeCamera();
        }
      } else {
        if (scaffold.currentState != null) {
          scaffold.currentState!.showSnackBar(const SnackBar(content: Text("Invalid QR code")));
        }
        controller.resumeCamera();
      }
    });
  }
}
