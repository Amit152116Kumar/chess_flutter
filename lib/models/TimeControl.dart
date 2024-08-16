class TimeControl {
  final Duration time;
  final Duration increment;

  const TimeControl({required this.time, required this.increment});
}

List<TimeControl> timeControls = const [
  TimeControl(time: Duration(minutes: 1), increment: Duration(seconds: 0)),
  TimeControl(time: Duration(minutes: 2), increment: Duration(seconds: 1)),
  TimeControl(time: Duration(minutes: 3), increment: Duration(seconds: 0)),
  TimeControl(time: Duration(minutes: 3), increment: Duration(seconds: 2)),
  TimeControl(time: Duration(minutes: 5), increment: Duration(seconds: 0)),
  TimeControl(time: Duration(minutes: 5), increment: Duration(seconds: 3)),
  TimeControl(time: Duration(minutes: 10), increment: Duration(seconds: 0)),
  TimeControl(time: Duration(minutes: 10), increment: Duration(seconds: 5)),
  TimeControl(time: Duration(minutes: 15), increment: Duration(seconds: 10)),
  TimeControl(time: Duration(minutes: 30), increment: Duration(seconds: 0)),
  TimeControl(time: Duration(minutes: 30), increment: Duration(seconds: 20))
];
