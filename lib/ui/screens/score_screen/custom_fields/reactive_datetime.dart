import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveDatetime extends ReactiveFormField<double, double> {
  ReactiveDatetime({Key? key, required String formControlName, required String label})
      : super(
          key: key,
          formControlName: formControlName,
          builder: (reactiveFormFieldState) => _ReactiveDatetime(formFieldState: reactiveFormFieldState, label: label),
        );
}

class _ReactiveDatetime extends StatefulWidget {
  const _ReactiveDatetime({Key? key, required this.formFieldState, required this.label}) : super(key: key);
  final ReactiveFormFieldState<double, double> formFieldState;
  final String label;

  @override
  State<_ReactiveDatetime> createState() => _ReactiveDatetimeState();
}

class _ReactiveDatetimeState extends State<_ReactiveDatetime> {
  TimeOfDay _time = TimeOfDay.now();

  String get timeString {
    final value = widget.formFieldState.value;
    if (value == null) {
      return 'Podaj czas';
    }
    return '${value.toStringAsFixed(3)}s';
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: const Text('SELECT TIME'),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected time: ${_time.format(context)}',
            ),
          ],
        ),
      ),
    );
  }
}
