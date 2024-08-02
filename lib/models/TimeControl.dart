class TimeControl {
  final int minutes;
  final Duration increment;

  TimeControl({required this.minutes, required this.increment});
}

List<TimeControl> timeControls = [
  TimeControl(minutes: 1, increment: const Duration(seconds: 0)),
  TimeControl(minutes: 2, increment: const Duration(seconds: 1)),
  TimeControl(minutes: 3, increment: const Duration(seconds: 0)),
  TimeControl(minutes: 3, increment: const Duration(seconds: 2)),
  TimeControl(minutes: 5, increment: const Duration(seconds: 0)),
  TimeControl(minutes: 5, increment: const Duration(seconds: 3)),
  TimeControl(minutes: 10, increment: const Duration(seconds: 0)),
  TimeControl(minutes: 10, increment: const Duration(seconds: 5)),
  TimeControl(minutes: 15, increment: const Duration(seconds: 10)),
  TimeControl(minutes: 30, increment: const Duration(seconds: 0)),
  TimeControl(minutes: 30, increment: const Duration(seconds: 20))
];
