import 'package:chess_flutter/main.dart';
import 'package:chess_flutter/models/BoardTheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardThemeScreen extends StatefulWidget {
  const BoardThemeScreen({super.key});

  @override
  State<BoardThemeScreen> createState() => _BoardThemeScreenState();
}

class _BoardThemeScreenState extends State<BoardThemeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Board Theme'),
        ),
        body: ListView.builder(
            itemCount: boardThemes.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                height: height * 0.1,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: const [0.0, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      appTheme.secondaryColor,
                      const Color(0xFF303A53),
                    ],
                  ),
                ),
                child: ListTile(
                  dense: true,
                  leading: myBoardTheme == boardThemes[index]
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                  title: Text(boardThemes[index].boardAsset.split("/").last.split(".").first,
                      style: const TextStyle(fontSize: 20, color: Colors.white)),
                  trailing: Image(
                      image: AssetImage(boardThemes[index].boardAsset), width: 50, height: 50),
                  onTap: () {
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setString('boardTheme', boardThemes[index].boardAsset);
                      setState(() {
                        myBoardTheme = boardThemes[index];
                      });
                    });
                  },
                ),
              );
            }));
  }
}
