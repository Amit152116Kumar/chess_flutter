import 'package:chess_flutter/backend/GameClass.dart';
import 'package:chess_flutter/backend/helper.dart';
import 'package:chess_flutter/models/Square.dart';
import 'package:chess_flutter/models/Themes.dart';
import 'package:flutter/material.dart';

class ChessBoardUI extends StatefulWidget {
  final bool isFlipped;
  final void Function(int, bool) pressClock;

  const ChessBoardUI({super.key, required this.isFlipped, required this.pressClock});

  @override
  State<ChessBoardUI> createState() => _ChessBoardUIState();
}

class _ChessBoardUIState extends State<ChessBoardUI> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game(startFEN);
  }

  // TODO: add audio for move

  void pieceSelected(int idx) {
    setState(() {
      if (game.isSelectedSquare && game.legalMoves.contains(idx)) {
        widget.pressClock(game.score, !game.fen.turnOfWhite);
        game.makeMove(idx);
      } else if (game.fen.turnOfWhite == game.fen.board[idx].piece?.isWhitePiece) {
        game.setSelectedSquareIdx(idx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
            itemCount: 64,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder: (context, index) {
              Square square = game.fen.board[index];

              bool isSelected = game.isSelectedSquare && game.selectedSquare.idx == index;
              bool isValidMove = game.legalMoves.contains(index);

              return DragTarget<Square>(onWillAcceptWithDetails: (detail) {
                return isValidMove;
              }, onAcceptWithDetails: (detail) {
                pieceSelected(index);
              }, builder: (context, candidateData, rejectedData) {
                return SquareUI(
                    square: square,
                    isSelected: isSelected,
                    isValidMove: isValidMove,
                    onTap: () => pieceSelected(index),
                    gameColor: defaultTheme);
              });
            }));
  }
}

class SquareUI extends StatelessWidget {
  final Square square;
  final bool isSelected;
  final bool isValidMove;
  final void Function() onTap;
  final GameTheme gameColor;

  const SquareUI(
      {super.key,
      required this.square,
      required this.isSelected,
      required this.isValidMove,
      required this.onTap,
      required this.gameColor});

  @override
  Widget build(BuildContext context) {
    var color = square.isWhiteSquare ? gameColor.whiteSquare : gameColor.blackSquare;
    var altColor = square.isWhiteSquare ? gameColor.blackSquare : gameColor.whiteSquare;
    double textFontSize = 12;
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(2),
            color: isSelected ? gameColor.selectedSquare : color,
            child: GridTile(
                // header and footer are used to display rank and file
                header: () {
                  if (square.idx % 8 == 0) {
                    return Container(
                        alignment: Alignment.topLeft,
                        child: Text("${square.rank + 1}",
                            style: TextStyle(color: altColor, fontSize: textFontSize)));
                  }
                }(),
                footer: () {
                  if (square.idx < 8) {
                    return Container(
                        alignment: Alignment.bottomRight,
                        child: Text(String.fromCharCode(square.file + 97),
                            style: TextStyle(fontSize: textFontSize, color: altColor)));
                  }
                }(),
                child: Stack(fit: StackFit.expand, alignment: Alignment.center, children: [
                  if (square.piece != null)
                    Draggable<Square>(
                        onDragStarted: onTap,
                        data: square,
                        feedback: Image.asset(square.piece!.asset, scale: 1.2),
                        childWhenDragging: Image.asset(square.piece!.asset,
                            opacity: const AlwaysStoppedAnimation(0.5), fit: BoxFit.cover),
                        child: Image.asset(square.piece!.asset, fit: BoxFit.fill)),
                  if (isValidMove)
                    // show legal move indicator
                    Container(
                        margin: square.piece != null
                            ? const EdgeInsets.all(0)
                            : const EdgeInsets.all(10),
                        decoration:
                            BoxDecoration(color: gameColor.legalMove, shape: BoxShape.circle))
                ]))));
  }
}
