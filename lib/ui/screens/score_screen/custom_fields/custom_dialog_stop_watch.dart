import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CustomDialogStopWatch extends StatefulWidget {
  const CustomDialogStopWatch({Key? key, required this.initialTime}) : super(key: key);
  final double initialTime;

  @override
  _CustomDialogStopWatchState createState() => _CustomDialogStopWatchState();
}

class _CustomDialogStopWatchState extends State<CustomDialogStopWatch> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.setPresetTime(mSec: (widget.initialTime * 1000).toInt(), add: false);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: _stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          final value = snap.data;
          final displayTime = StopWatchTimer.getDisplayTime(value ?? 0);
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                displayTime,
                style: const TextStyle(fontSize: 40, fontFamily: 'Helvetica', fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ]);
        },
      ),
      Padding(
        padding: const EdgeInsets.all(2),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: RaisedButton(
                  padding: const EdgeInsets.all(4),
                  color: Colors.lightBlue,
                  shape: const StadiumBorder(),
                  onPressed: () async {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: RaisedButton(
                  padding: const EdgeInsets.all(4),
                  color: Colors.green,
                  shape: const StadiumBorder(),
                  onPressed: () async => _stopWatchTimer.onExecute.add(StopWatchExecute.stop),
                  child: const Text('Stop', style: TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: RaisedButton(
                  padding: const EdgeInsets.all(4),
                  color: Colors.red,
                  shape: const StadiumBorder(),
                  onPressed: () async {
                    _stopWatchTimer.setPresetTime(mSec: 0, add: false);
                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                  },
                  child: const Text('Reset', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: RaisedButton(
                padding: const EdgeInsets.all(4),
                color: Colors.black,
                shape: const StadiumBorder(),
                onPressed: () async {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  Navigator.of(context).pop<double>(_stopWatchTimer.rawTime.value / 1000);
                },
                child: const Text('Zaakceptuj wynik', style: TextStyle(color: Colors.white)),
              ),
            ),
          ]),
        ]),
      )
    ]);
  }
}
