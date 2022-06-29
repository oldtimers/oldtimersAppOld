import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../model/crew.dart';
import '../../model/event.dart';
import '../../utils/my_database.dart';

class ManualCrewDialog extends StatefulWidget {
  final AuthenticationBloc authBloc;
  final Function(Crew) actionOnEnd;
  final Event event;

  const ManualCrewDialog(this.authBloc, this.actionOnEnd, this.event);

  @override
  _ManualCrewDialogState createState() => _ManualCrewDialogState();
}

class _ManualCrewDialogState extends State<ManualCrewDialog> {
  late TextEditingController numberController;

  @override
  void initState() {
    numberController = TextEditingController();
  }

  void sendData() async {
    setState(() {
      loading = true;
    });
    Crew? crew = await MyDatabase.getCrewByNr(int.parse(numberController.value.text), widget.event, widget.authBloc);
    if (crew == null) {
      numberController.clear();
      setState(() {
        loading = false;
      });
    } else {
      Navigator.of(context).pop();
      widget.actionOnEnd(crew);
    }
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return !loading
        ? AlertDialog(
            title: Text(
              "Wpisz numer załogi",
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
            ],
            content: TextField(
              controller: numberController,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Numer załogi', hintText: 'Wprowadź numer załogi'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
