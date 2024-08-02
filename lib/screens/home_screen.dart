import 'package:chess_flutter/screens/game_screen.dart';
import 'package:flutter/material.dart';

import '../models/TimeControl.dart';

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
    return timeControl.minutes > 15
        ? "Classical"
        : timeControl.minutes >= 10
            ? "Rapid"
            : timeControl.minutes >= 3
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
                  Text("${timeControl.minutes}+${timeControl.increment.inSeconds.toString()}",
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
        onTap: () async {
          final timeControl = await showDialog<TimeControl>(
              context: context, builder: (context) => CustomGameDialog());

          if (timeControl != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GameScreen(timeControl: timeControl)));
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
  String side = 'Random Side';
  String variant = 'Standard';
  String timeControl = 'Real time';
  double minutesPerSide = 5;
  double incrementInSeconds = 3;
  bool isRated = true;
  double ratingRange = 500;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Create a custom game'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Text('Side: ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
                value: side,
                items: <String>['Random Side', 'White', 'Black'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    side = newValue!;
                  });
                })
          ]),
          Row(children: [
            Text('Variant: ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
                value: variant,
                items: <String>['Standard', 'Blitz', 'Bullet'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    variant = newValue!;
                  });
                })
          ]),
          Row(children: [
            Text('Time control: ',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
                value: timeControl,
                items: <String>['Real time', 'Correspondence'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    timeControl = newValue!;
                  });
                })
          ]),
          Text('Minutes per side: ${minutesPerSide.toInt()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
              value: minutesPerSide,
              min: 1,
              max: 60,
              divisions: 59,
              label: minutesPerSide.round().toString(),
              onChanged: (double value) {
                setState(() {
                  minutesPerSide = value;
                });
              }),
          Text('Increment in seconds: ${incrementInSeconds.toInt()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
              value: incrementInSeconds,
              min: 0,
              max: 60,
              divisions: 60,
              label: incrementInSeconds.round().toString(),
              onChanged: (double value) {
                setState(() {
                  incrementInSeconds = value;
                });
              }),
          SwitchListTile(
              title:
                  Text('Rated', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              max: 1000,
              divisions: 1000,
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
              child: Text('Cancel',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          TextButton(
              onPressed: () {
                // Handle create game action
                Navigator.of(context).pop(TimeControl(
                    minutes: minutesPerSide.toInt(),
                    increment: Duration(seconds: incrementInSeconds.toInt())));
              },
              child:
                  Text('Create', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
        ]);
  }
}
