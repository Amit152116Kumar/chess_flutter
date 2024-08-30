import 'package:chess_flutter/main.dart';
import 'package:chess_flutter/models/PieceSets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PieceSetScreen extends StatefulWidget {
  const PieceSetScreen({super.key});

  @override
  State<PieceSetScreen> createState() => _PieceSetScreenState();
}

class _PieceSetScreenState extends State<PieceSetScreen> {
  @override
  Widget build(BuildContext context) {
    var selectedPieceSet = myPieceSet.name;
    var height = MediaQuery.of(context).size.height / 9;
    double size = 28;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Piece Set'),
        ),
        body: ListView.builder(
            itemCount: pieceSetNames.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                height: height,
                padding: const EdgeInsets.all(1),
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
                  leading: selectedPieceSet == pieceSetNames[index]
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                  title: Text(pieceSetNames[index].toUpperCase(),
                      style: const TextStyle(fontSize: 20, color: Colors.white)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Image(
                              image: AssetImage("assets/piece_sets/${pieceSetNames[index]}/bK.png"),
                              width: size,
                              height: size),
                          Image(
                              image: AssetImage("assets/piece_sets/${pieceSetNames[index]}/wK.png"),
                              width: size,
                              height: size),
                        ],
                      ),
                      Column(
                        children: [
                          Image(
                              image: AssetImage("assets/piece_sets/${pieceSetNames[index]}/bQ.png"),
                              width: size,
                              height: size),
                          Image(
                              image: AssetImage("assets/piece_sets/${pieceSetNames[index]}/wQ.png"),
                              width: size,
                              height: size),
                        ],
                      ),
                    ],
                  ),
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('pieceSet', pieceSetNames[index]);
                    setState(() {
                      myPieceSet.changePieceSet(pieceSetNames[index]);
                    });
                  },
                ),
              );
            }));
  }
}
