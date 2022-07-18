import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/competition.dart';
import 'package:oldtimers_rally_app/model/competition_field.dart';
import 'package:oldtimers_rally_app/model/crew.dart';
import 'package:oldtimers_rally_app/model/event.dart';
import 'package:oldtimers_rally_app/ui/screens/score_screen/custom_fields/reactive_stop_watch_timer.dart';
import 'package:oldtimers_rally_app/utils/data_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sprintf/sprintf.dart';

class CustomScreen extends StatefulWidget {
  final Crew crew;
  final Competition competition;
  final Event event;
  final List<CompetitionField> fields;

  const CustomScreen({Key? key, required this.crew, required this.competition, required this.event, required this.fields}) : super(key: key);

  @override
  _CustomScreenState createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  static final NumberFormat formatter = NumberFormat("00");
  late AuthenticationBloc authBloc;
  late FormGroup formGroup;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    formGroup = generateFormGroup(widget.fields);
    super.initState();
  }

  FormGroup generateFormGroup(List<CompetitionField> fields) {
    final Map<String, FormControl> controls = Map.fromIterable(
      fields,
      key: (competitionField) => (competitionField as CompetitionField).order.toString(),
      value: (competitionField) {
        switch ((competitionField as CompetitionField).type) {
          case FieldType.FLOAT:
            return FormControl<double>(validators: [Validators.required]);
          case FieldType.INT:
            return FormControl<int>(validators: [Validators.required]);
          case FieldType.BOOLEAN:
            return FormControl<bool>(value: false, validators: [Validators.required]);
          case FieldType.TIMER:
            return FormControl<double>(validators: [
              Validators.required,
            ]);
          case FieldType.DATETIME:
            return FormControl<TimeOfDay>(validators: [Validators.required]);
        }
      },
    );
    return FormGroup(controls);
  }

  List<Widget> generateFormFields() {
    return widget.fields.map((competitionField) {
      switch (competitionField.type) {
        case FieldType.INT:
          return ReactiveTextField(
            formControlName: competitionField.order.toString(),
            decoration: InputDecoration(label: Text(competitionField.label)),
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
            validationMessages: (_) => {
              ValidationMessage.required: 'Blank/Invalid value (INT)',
              ValidationMessage.number: 'Must be a number',
            },
          );
        case FieldType.FLOAT:
          return ReactiveTextField(
            formControlName: competitionField.order.toString(),
            decoration: InputDecoration(label: Text(competitionField.label)),
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            validationMessages: (_) => {
              ValidationMessage.required: 'Blank/Invalid value (FLOAT)',
              ValidationMessage.number: 'Must be a number',
            },
          );
        case FieldType.BOOLEAN:
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(competitionField.label),
              ReactiveSwitch(formControlName: competitionField.order.toString()),
            ],
          );
        case FieldType.TIMER:
          return ReactiveStopWatchTimer(formControlName: competitionField.order.toString(), label: competitionField.label);
        case FieldType.DATETIME:
          return ReactiveTimePicker(
              formControlName: competitionField.order.toString(),
              builder: (context, picker, child) {
                return InkWell(
                  onTap: () => picker.showPicker(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(competitionField.label),
                      Row(children: [
                        const Icon(Icons.access_time),
                        Text(picker.value != null
                            ? sprintf.call("  %s:%s", [formatter.format(picker.value!.hour), formatter.format(picker.value!.minute)])
                            : "Wprowadź wartość")
                      ]),
                    ],
                  ),
                );
              });
      }
    }).toList();
  }

  void showPopup() async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          var timestamp = DateTime.now().toUtc();
          return ConfirmDialog(widget.crew, timestamp, widget.competition, authBloc, widget.event);
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ReactiveForm(
      formGroup: formGroup,
      child: Scaffold(
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
                children: const [
                  Text(
                    "WYNIKI",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
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
          // decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('resources/time_background.jpg'), fit: BoxFit.cover)),
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                sprintf("Załoga: %d, %s", [widget.crew.number, widget.crew.driverName]),
                style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 0.05 * width, right: 0.05 * width),
                itemBuilder: (context, index) => generateFormFields()[index],
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: widget.fields.length,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.01 * height),
                child: FlatButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  splashColor: Colors.blueAccent,
                  padding: const EdgeInsets.all(30),
                  onPressed: () async {
                    if (formGroup.valid) {
                      await DataRepository.setResult(widget.competition, widget.crew, widget.event, formGroup.value, authBloc);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Wyślij", style: TextStyle(fontSize: 20.0)),
                ),
              ),
              if (widget.competition.possibleInvalid)
                Padding(
                  padding: EdgeInsets.only(bottom: 0.01 * height),
                  child: FlatButton(
                    color: Colors.black,
                    textColor: Colors.red,
                    splashColor: Colors.blueAccent,
                    padding: const EdgeInsets.all(30),
                    onPressed: () async {
                      // await DataRepository.setResult(widget.competition, widget.crew, widget.event, {"invalidResult": true}, authBloc);
                      // Navigator.of(context).pop();
                      showPopup();
                    },
                    child: const Text("Unieważnij wynik", style: TextStyle(fontSize: 20.0)),
                  ),
                ),
            ],
          ),
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
  final Event event;

  const ConfirmDialog(this.crew, this.timestamp, this.competition, this.authBloc, this.event);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  void sendData() async {
    setState(() {
      loading = true;
    });
    await DataRepository.setResult(widget.competition, widget.crew, widget.event, {"invalidResult": true}, widget.authBloc);
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return !loading
        ? AlertDialog(
            title: Text(
              "Czy na pewno chcesz unieważnić wynik tej załogi?",
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
              ])
        : const Center(child: CircularProgressIndicator());
  }
}
