import 'dart:async';

import 'package:chess_flutter/backend/helper.dart';
import 'package:chess_flutter/main.dart';
import 'package:chess_flutter/models/TimeControl.dart';
import 'package:chess_flutter/models/User.dart';
import 'package:chess_flutter/screens/setting_screen.dart';
import 'package:chess_flutter/widget/chessboard.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final TimeControl timeControl;

  const GameScreen({super.key, required this.timeControl});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isFlipped = false;
  int tabIdx = 0;

  Map<GameStatus, List<BottomNavigationBarItem>> bottomNavItems = {
    GameStatus.inProgress: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Options'),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.arrow_back_ios), label: 'Back'),
      BottomNavigationBarItem(icon: Icon(Icons.arrow_forward_ios), label: 'Forward')
    ],
    GameStatus.gameOver: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Options'),
      BottomNavigationBarItem(icon: Icon(Icons.saved_search), label: 'Analyze'),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.arrow_back_ios), label: 'Back'),
      BottomNavigationBarItem(icon: Icon(Icons.arrow_forward_ios), label: 'Forward')
    ],
  };
  bool turnOfWhite = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Flutter Chess"), centerTitle: true),
        body: Container(
            alignment: Alignment.topCenter,
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const MoveHistoryUI(),
              const Padding(padding: EdgeInsets.all(10)),
              Column(children: [
                UserWithTimer(
                    user: const User(
                        name: "Guest 1",
                        imageUrl: "https://www.linkedin.com/favicon.ico",
                        rating: 1800),
                    timeControl: widget.timeControl,
                    myTurn: !turnOfWhite),
                const SizedBox(height: 15),
                ChessBoardUI(isFlipped: isFlipped, pressClock: pressClock),
                const SizedBox(height: 15),
                UserWithTimer(
                    user: const User(
                        name: "Guest 2",
                        imageUrl: "https://www.github.com/favicon"
                            ".ico",
                        rating: 1599),
                    myTurn: turnOfWhite,
                    timeControl: widget.timeControl)
              ])
            ])),
        bottomNavigationBar: BottomNavigationBar(
            onTap: _setTabIdx,
            currentIndex: tabIdx,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: bottomNavItems[GameStatus.inProgress]!));
  }

  void pressClock(int score, bool turnOfWhite) {
    setState(() {
      this.turnOfWhite = turnOfWhite;
    });
  }

  void _setTabIdx(int value) {
    if (value == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            TextStyle optionsStyle = TextStyle(color: appTheme.primaryColor, fontSize: 18);
            return AlertDialog(
                title: Text('Game Options'),
                backgroundColor: appTheme.secondaryColor,
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  ListTile(
                      title: Text('Abort', style: optionsStyle),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      title: Text('Resign', style: optionsStyle),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      title: Text('Settings', style: optionsStyle),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SettingScreen()));
                      })
                ]));
          });
    }
  }
}

class MoveHistoryUI extends StatefulWidget {
  const MoveHistoryUI({super.key});

  @override
  State<MoveHistoryUI> createState() => _MoveHistoryUIState();
}

class _MoveHistoryUIState extends State<MoveHistoryUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        color: appTheme.primaryColor,
        child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              return RichText(
                  text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      children: [
                    TextSpan(text: "$index."),
                    const TextSpan(text: " "),
                    WidgetSpan(
                        child: Image.asset("assets/images/white_pawn.png",
                            fit: BoxFit.fill, height: 20)),
                    const TextSpan(text: "e4"),
                    const TextSpan(text: "  "),
                    WidgetSpan(
                        child: Image.asset("assets/images/black_pawn.png",
                            fit: BoxFit.fill, height: 20)),
                    const TextSpan(text: "e5"),
                    const TextSpan(text: "     ")
                  ]));
            }));
  }
}

class UserWithTimer extends StatefulWidget {
  final TimeControl timeControl;
  final User user;
  final bool myTurn;

  const UserWithTimer(
      {super.key, required this.user, required this.timeControl, required this.myTurn});

  @override
  State<UserWithTimer> createState() => _UserWithTimerState();
}

class _UserWithTimerState extends State<UserWithTimer> {
  Timer? timer;
  late Duration time;

  @override
  void initState() {
    time = Duration(minutes: widget.timeControl.minutes);
    if (widget.myTurn) {
      startTimer();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(UserWithTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.myTurn != widget.myTurn) {
      if (widget.myTurn) {
        startTimer();
      } else {
        stopTimer();
      }
    }
  }

  void startTimer() {
    int remMilliSeconds = time.inMilliseconds;
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (remMilliSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          time = Duration(milliseconds: --remMilliSeconds);
        });
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      time =
          Duration(milliseconds: time.inMilliseconds + widget.timeControl.increment.inMilliseconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: widget.user.imageUrl.isNotEmpty
                        ? Image.network(widget.user.imageUrl, fit: BoxFit.cover)
                        : const Icon(Icons.person)),
                const SizedBox(width: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                              children: [
                            TextSpan(
                                text: widget.user.name,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " (${widget.user.rating})")
                          ])),
                      const Padding(padding: EdgeInsets.all(2)),
                      Row(
                          // To display the taken pieces of opponent
                          children: [
                            Image.asset("assets/images/black_queen.png", height: 20),
                            Image.asset("assets/images/black_pawn.png", height: 20)
                          ])
                    ])
              ]),
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade300, borderRadius: BorderRadius.circular(10)),
              child: timerWidget)
        ]));
  }

  Widget get timerWidget {
    int minutes = time.inMinutes;
    int seconds = time.inSeconds % 60;
    int milliseconds = (time.inMilliseconds % 1000) ~/ 100;

    return RichText(
        text: TextSpan(style: const TextStyle(color: Colors.white), children: [
      TextSpan(
          text: "${minutes < 10 ? "0$minutes" : minutes}:", style: const TextStyle(fontSize: 28)),
      TextSpan(
          text: "${seconds < 10 ? "0$seconds" : seconds}", style: const TextStyle(fontSize: 28)),
      TextSpan(text: ".$milliseconds", style: const TextStyle(fontSize: 21))
    ]));
  }
}
