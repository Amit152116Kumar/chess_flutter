import 'package:chess_flutter/models/TimeControl.dart';
import 'package:chess_flutter/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), centerTitle: true, elevation: 10),
        body: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                          itemCount: 12,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 1.3),
                          itemBuilder: (context, index) {
                            if (index == 11) {
                              return const CustomGameButton();
                            }
                            return TimeControlBox(timeControl: timeControls[index]);
                          }))
                ])),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blueGrey.shade500,
            currentIndex: tabIdx,
            onTap: _setTabIdx,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu")
            ]));
  }

  void _setTabIdx(int index) {
    setState(() {
      tabIdx = index;
    });
  }
}

class TimeControlBox extends StatelessWidget {
  final TimeControl timeControl;

  const TimeControlBox({super.key, required this.timeControl});

  String get event {
    return timeControl.time.inMinutes > 15
        ? "Classical"
        : timeControl.time.inMinutes >= 10
            ? "Rapid"
            : timeControl.time.inMinutes >= 3
                ? "Blitz"
                : "Bullet";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GameScreen(timeControl: timeControl)));
        },
        child: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.grey),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${timeControl.time.inMinutes}+${timeControl.increment.inSeconds}",
                      style: const TextStyle(fontSize: 25)),
                  Text(event, style: const TextStyle(fontSize: 20))
                ])));
  }
}

class CustomGameButton extends StatefulWidget {
  const CustomGameButton({super.key});

  @override
  State<CustomGameButton> createState() => _CustomGameButtonState();
}

class _CustomGameButtonState extends State<CustomGameButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          TimeControl? timeControl;
          showDialog<TimeControl>(context: context, builder: (context) => const CustomGameDialog())
              .then((value) {
            timeControl = value;
          });

          if (timeControl != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GameScreen(timeControl: timeControl!)));
          }
        },
        child: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.grey),
            child: const Center(child: Text("Custom", style: TextStyle(fontSize: 25)))));
  }
}

class CustomGameDialog extends StatefulWidget {
  const CustomGameDialog({super.key});

  @override
  State<CustomGameDialog> createState() => _CustomGameDialogState();
}

class _CustomGameDialogState extends State<CustomGameDialog> {
  bool isRated = true;
  double ratingRange = 250;

  double _minuteSliderValue = 9;
  double _incrementSliderValue = 3;

  double _getMinuteMappedValue() {
    if (_minuteSliderValue <= 4) {
      return _minuteSliderValue * 0.25;
    } else if (_minuteSliderValue <= 24) {
      return _minuteSliderValue - 4;
    } else if (_minuteSliderValue <= 29) {
      return 20 + (_minuteSliderValue - 24) * 5;
    } else {
      return 45 + (_minuteSliderValue - 29) * 15;
    }
  }

  double _getIncrementMappedValue() {
    if (_incrementSliderValue <= 20) {
      return _incrementSliderValue;
    } else if (_incrementSliderValue <= 25) {
      return 20 + (_incrementSliderValue - 20) * 5;
    } else if (_incrementSliderValue == 26) {
      return 60;
    } else {
      return 60 + (_incrementSliderValue - 26) * 30;
    }
  }

  String fractionToString(double value) {
    if (value > 0 && value < 1) {
      return Fraction.fromDouble(value).toStringAsGlyph();
    }
    return value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    double mappedMinuteValue = _getMinuteMappedValue();
    int mappedIncrementValue = _getIncrementMappedValue().toInt();
    String minutes = fractionToString(mappedMinuteValue);
    return AlertDialog(
        title: const Text('Create a custom game'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 10),
          Text('Minutes per side: $minutes',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
              value: _minuteSliderValue,
              min: 0,
              max: 34,
              divisions: 34,
              label: minutes,
              onChanged: (double value) {
                setState(() {
                  _minuteSliderValue = value;
                });
              }),
          Text('Increment in seconds: $mappedIncrementValue',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
              value: _incrementSliderValue,
              min: 0,
              max: 30,
              divisions: 30,
              label: mappedIncrementValue.toString(),
              onChanged: (double value) {
                setState(() {
                  _incrementSliderValue = value;
                });
              }),
          SwitchListTile(
              title:
                  const Text('Rated', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              value: isRated,
              onChanged: (bool value) {
                setState(() {
                  isRated = value;
                });
              }),
          Text('Rating range: ±${ratingRange.toInt()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
              value: ratingRange,
              min: 0,
              max: 500,
              divisions: 500,
              label: ratingRange.round().toString(),
              onChanged: (double value) {
                setState(() {
                  ratingRange = value;
                });
              })
        ]),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          TextButton(
              onPressed: () {
                // Handle create game action
                Duration time;
                if (mappedMinuteValue >= 1) {
                  time = Duration(minutes: mappedMinuteValue.toInt());
                } else if (mappedMinuteValue > 0) {
                  time = Duration(seconds: (mappedMinuteValue * 60).toInt());
                } else {
                  time = Duration(seconds: mappedIncrementValue.toInt());
                }

                Navigator.of(context).pop(
                    TimeControl(time: time, increment: Duration(seconds: mappedIncrementValue)));
              },
              child:
                  const Text('Create', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
        ]);
  }
}
