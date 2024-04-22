import 'package:chess_flutter/widget/chessBoard.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late bool isFlipped = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Chess"),
          centerTitle: true,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Center(
              child: ChessBoardUI(
            isFlipped: isFlipped,
            stopTime: stopTime,
          )),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _setTabIdx,
          currentIndex: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flip_camera_android),
              label: 'Flip',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ));
  }

  void stopTime(int score) {
    print("Game Over, Score: $score");
  }

  void _setTabIdx(int value) {
    if (value == 1) {
      setState(() {
        isFlipped = !isFlipped;
      });
    }
  }
}

class UserWithTimer extends StatefulWidget {
  const UserWithTimer({super.key});

  @override
  State<UserWithTimer> createState() => _UserWithTimerState();
}

class _UserWithTimerState extends State<UserWithTimer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black,
              ),
            ),
            Column(
              children: [
                Text("User Name"),
                Text("Rating: 1200"),
              ],
            ),
          ],
        ),
        Text("Time: 10:00",
            style: TextStyle(
                fontSize: 20,
                backgroundColor: Colors.black,
                color: Colors.white)),
      ],
    );
  }
}
