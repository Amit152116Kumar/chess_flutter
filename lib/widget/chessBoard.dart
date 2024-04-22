import 'package:chess_flutter/backend/GameClass.dart';
import 'package:chess_flutter/backend/SquareClass.dart';
import 'package:chess_flutter/backend/helper.dart';
import 'package:chess_flutter/widget/color.dart';
import 'package:flutter/material.dart';

class ChessBoardUI extends StatefulWidget {
  final bool isFlipped;
  final void Function(int) stopTime;
  const ChessBoardUI({super.key, required this.isFlipped, required this.stopTime});

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
        game.makeMove(idx);
        widget.stopTime(game.score);
      } else if (game.fen.turnOfWhite ==
          game.fen.board[idx].piece?.isWhitePiece) {
        game.setSelectedSquareIdx(idx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var aspectRatio = MediaQuery.of(context).size.aspectRatio;
    var orientation = MediaQuery.of(context).orientation;
    double size;
    if (orientation == Orientation.landscape) {
      size = height / 8;
    } else {
      size = width / 8;
    }

    return GridView.builder(
        itemCount: 64,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(21),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          Square square = game.fen.board[index];
          bool isFunctional = game.fen.turnOfWhite ==
                  game.fen.board[index].piece?.isWhitePiece ||
              game.fen.board[index].piece == null ||
              game.legalMoves.contains(index);
          bool isSelected =
              game.isSelectedSquare && game.selectedSquare.idx == index;
          bool isValidMove = game.legalMoves.contains(index);

          return SquareUI(
            square: square,
            isSelected: isSelected,
            isValidMove: isValidMove,
            onTap: () => pieceSelected(index),
            size: size,
          );
        });
  }
}

class SquareUI extends StatelessWidget {
  final Square square;
  final bool isSelected;
  final bool isValidMove;
  final double size;
  final void Function() onTap;
  const SquareUI(
      {super.key,
      required this.square,
      required this.isSelected,
      required this.isValidMove,
      required this.onTap,
      required this.size});

  @override
  Widget build(BuildContext context) {
    var color =
        square.isWhiteSquare ? GameColor.whiteSquare : GameColor.blackSquare;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(2),
          color: isSelected ? GameColor.selectedSquare : color,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Text(
                  "${square.idx} -> ${String.fromCharCode(square.file + 97)}${square.rank + 1}"),
              if (square.piece != null)
                Image.asset(square.piece!.asset, fit: BoxFit.fill),
              if (square.piece != null && isValidMove)
                Container(
                  decoration: BoxDecoration(
                    color: GameColor.legalMove,
                    shape: BoxShape.circle,
                  ),
                ),
              if (square.piece == null && isValidMove)
                Container(
                  margin: EdgeInsets.all(size * 0.25),
                  decoration: BoxDecoration(
                    color: GameColor.legalMove,
                    shape: BoxShape.circle,
                  ),
                )
            ],
          )),
    );
  }
}
