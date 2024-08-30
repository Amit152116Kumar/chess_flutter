import 'package:chess_flutter/models/AppTheme.dart';
import 'package:chess_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/BoardTheme.dart';
import 'models/PieceSets.dart';

void main() {
  SharedPreferences.getInstance().then((prefs) {
    var pieceSet = prefs.getString('pieceSet') ?? 'alpha';
    var boardTheme = prefs.getString('boardTheme') ?? 'assets/boards/blue2.jpg';
    myPieceSet.changePieceSet(pieceSet);
    myBoardTheme = boardThemes.firstWhere((element) => element.boardAsset == boardTheme);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chess',
        theme: ThemeData(
            scaffoldBackgroundColor: appTheme.secondaryColor,
            appBarTheme: AppBarTheme(
                color: appTheme.primaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: appTheme.secondaryColor,
                selectedItemColor: appTheme.accentColor1,
                unselectedItemColor: appTheme.accentColor2)),
        home: const HomeScreen(title: 'Flutter Chess'),
        debugShowCheckedModeBanner: false);
  }
}

final AppTheme appTheme = appColors2;
