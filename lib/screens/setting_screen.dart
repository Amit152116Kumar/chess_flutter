import 'package:chess_flutter/screens/background_theme_screen.dart';
import 'package:chess_flutter/screens/board_theme_screen.dart';
import 'package:chess_flutter/screens/piece_set_screen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool sound = true;
  bool confirmEachMove = false;
  bool autoQueen = false;

  @override
  Widget build(BuildContext context) {
    var textColor = Colors.white;
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(children: [
          ListTile(
            title: Text('Background', style: TextStyle(color: textColor)),
            trailing: Icon(Icons.arrow_forward_ios, color: textColor),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const BackgroundThemeScreen()));
            },
          ),
          ListTile(
            title: Text('Board Theme', style: TextStyle(color: textColor)),
            trailing: Icon(Icons.arrow_forward_ios, color: textColor),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const BoardThemeScreen()));
            },
          ),
          ListTile(
              title: Text('Piece Set', style: TextStyle(color: textColor)),
              trailing: Icon(Icons.arrow_forward_ios, color: textColor),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const PieceSetScreen()));
              }),
          ListTile(
              title: Text('Sound', style: TextStyle(color: textColor)),
              trailing: Switch(
                  value: sound,
                  onChanged: (value) {
                    setState(() {
                      sound = value;
                    });
                  })),
          ListTile(
              title: Text('Confirm Each Move', style: TextStyle(color: textColor)),
              trailing: Switch(
                  value: confirmEachMove,
                  onChanged: (value) {
                    setState(() {
                      confirmEachMove = value;
                    });
                  })),
          ListTile(
              title: Text('Auto-Queen', style: TextStyle(color: textColor)),
              trailing: Switch(
                  value: autoQueen,
                  onChanged: (value) {
                    setState(() {
                      autoQueen = value;
                    });
                  }))
        ]));
  }
}
