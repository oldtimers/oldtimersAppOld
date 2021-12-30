import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:oldtimers_rally_app/ui/screens/score_screen/custom_fields/custom_dialog_stop_watch.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveStopWatchTimer extends ReactiveFormField<double, double> {
  ReactiveStopWatchTimer({Key? key, required String formControlName, required String label})
      : super(
          key: key,
          formControlName: formControlName,
          builder: (reactiveFormFieldState) => _ReactiveStopWatchTimer(formFieldState: reactiveFormFieldState, label: label),
        );
}

class _ReactiveStopWatchTimer extends StatelessWidget {
  const _ReactiveStopWatchTimer({Key? key, required this.formFieldState, required this.label}) : super(key: key);
  final ReactiveFormFieldState<double, double> formFieldState;
  final String label;

  String get timeString {
    final value = formFieldState.value;
    if (value == null) {
      return 'Please enter time';
    }
    return '${value.toStringAsFixed(3)}s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (_) => CustomDialogStopWatch(initialTime: formFieldState.value ?? 0),
          ).then((value) {
            if (value is double) {
              formFieldState.control.updateValue(value);
            }
          }),
          child: Text(timeString),
        ),
      ],
    );
  }
}
