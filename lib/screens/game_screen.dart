import 'dart:async';

import 'package:chess_flutter/backend/helper.dart';
import 'package:chess_flutter/main.dart';
import 'package:chess_flutter/models/Piece.dart';
import 'package:chess_flutter/models/TimeControl.dart';
import 'package:chess_flutter/models/User.dart';
import 'package:chess_flutter/screens/setting_screen.dart';
import 'package:chess_flutter/widget/chessboard.dart';
import 'package:flutter/foundation.dart';
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
    ]
  };
  bool turnOfWhite = true;
  List<String> moves = [];

  List<Piece> takenPiecesByWhite = [];
  List<Piece> takenPiecesByBlack = [];

  int score = 0;

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
              MoveHistoryUI(moves: moves),
              const Padding(padding: EdgeInsets.all(10)),
              Column(children: [
                UserWithTimer(
                    user: const User(
                        name: "Guest 1",
                        imageUrl: "https://www.linkedin.com/favicon.ico",
                        rating: 1800),
                    timeControl: widget.timeControl,
                    takenPieces: takenPiecesByBlack,
                    score: score,
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
                    score: score,
                    myTurn: turnOfWhite,
                    takenPieces: takenPiecesByWhite,
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

  List<Piece> sortPieces(List<Piece> pieces) {
    mergeSort(pieces, compare: (a, b) {
      if (a.value == b.value) {
        return a.name.name.compareTo(b.name.name);
      }
      return b.value.abs().compareTo(a.value.abs());
    });
    return pieces;
  }

  void removeSamePiece() {
    for (int i = 0; i < takenPiecesByWhite.length; i++) {
      for (int j = 0; j < takenPiecesByBlack.length; j++) {
        if (takenPiecesByWhite[i].name == takenPiecesByBlack[j].name) {
          takenPiecesByWhite.removeAt(i);
          takenPiecesByBlack.removeAt(j);
          i--;
          break;
        }
      }
    }
  }

  void pressClock(int score, bool turnOfWhite, String move, Piece? piece) {
    setState(() {
      this.turnOfWhite = turnOfWhite;
      this.score = score;
      moves.add(move);
      if (piece == null) {
        return;
      }
      if (piece.isWhitePiece) {
        takenPiecesByBlack.add(piece);
        takenPiecesByBlack = sortPieces(takenPiecesByBlack);
      } else {
        takenPiecesByWhite.add(piece);
        takenPiecesByWhite = sortPieces(takenPiecesByWhite);
      }
      removeSamePiece();
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

// TODO  Add scrolling to moves when it is made & also correct the move history shown
class MoveHistoryUI extends StatefulWidget {
  final List<String> moves;

  const MoveHistoryUI({super.key, required this.moves});

  @override
  State<MoveHistoryUI> createState() => _MoveHistoryUIState();
}

class _MoveHistoryUIState extends State<MoveHistoryUI> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(MoveHistoryUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moves.length != widget.moves.length) {
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 10), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.moves);
    return Container(
        height: 30,
        color: appTheme.primaryColor,
        child: ListView.builder(
            itemCount: (widget.moves.length / 2).ceil(),
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              int moveIndex = index * 2;
              bool hasBlackMove = moveIndex + 1 < widget.moves.length;
              return RichText(
                  text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      children: [
                    TextSpan(text: "${index + 1}."),
                    const TextSpan(text: " "),
                    WidgetSpan(
                        child: Image.asset("assets/images/white_pawn.png",
                            fit: BoxFit.fill, height: 20)),
                    TextSpan(text: widget.moves[moveIndex]),
                    const TextSpan(text: "  "),
                    if (hasBlackMove) ...[
                      WidgetSpan(
                          child: Image.asset("assets/images/black_pawn.png",
                              fit: BoxFit.fill, height: 20)),
                      TextSpan(text: widget.moves[moveIndex + 1]),
                      const TextSpan(text: "     ")
                    ]
                  ]));
            }));
  }
}

class UserWithTimer extends StatefulWidget {
  final TimeControl timeControl;
  final User user;
  final bool myTurn;
  final List<Piece> takenPieces;
  final int score;

  const UserWithTimer(
      {super.key,
      required this.user,
      required this.timeControl,
      required this.myTurn,
      required this.takenPieces,
      required this.score});

  @override
  State<UserWithTimer> createState() => _UserWithTimerState();
}

class _UserWithTimerState extends State<UserWithTimer> {
  Timer? timer;
  late Duration time;

  @override
  void initState() {
    super.initState();
    time = widget.timeControl.time;
    if (widget.myTurn) {
      startTimer();
    }
  }

  @override
  void didUpdateWidget(UserWithTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.myTurn == widget.myTurn) return;
    if (widget.myTurn) {
      startTimer();
    } else {
      stopTimer();
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      // To display the taken pieces of opponent
                      Row(children: [
                        if (widget.takenPieces.isNotEmpty)
                          for (var piece in widget.takenPieces)
                            Image.asset(piece.asset, height: 20, width: 20, fit: BoxFit.fill),
                        if (widget.takenPieces.isEmpty) const SizedBox(height: 20)
                      ])
                    ])
              ]),
          timerWidget
        ]));
  }

  Widget get timerWidget {
    int minutes = time.inMinutes;
    int seconds = time.inSeconds % 60;
    int milliseconds = (time.inMilliseconds % 1000) ~/ 100;

    var color = widget.myTurn
        ? time.inSeconds > 10
            ? Colors.green.shade800.withOpacity(0.5)
            : Colors.red.shade900.withOpacity(0.75)
        : time.inSeconds > 10
            ? Colors.grey.shade900
            : Colors.red.shade900.withAlpha(80);

    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: RichText(
            text: TextSpan(style: const TextStyle(color: Colors.white), children: [
          TextSpan(
              text: "${minutes < 10 ? "0$minutes" : minutes}",
              style: const TextStyle(fontSize: 28)),
          const TextSpan(text: ":", style: TextStyle(fontSize: 28)),
          TextSpan(
              text: "${seconds < 10 ? "0$seconds" : seconds}",
              style: const TextStyle(fontSize: 28)),
          TextSpan(text: ".$milliseconds", style: const TextStyle(fontSize: 21))
        ])));
  }
}
