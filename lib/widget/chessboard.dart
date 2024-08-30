import 'package:chess_flutter/backend/GameClass.dart';
import 'package:chess_flutter/backend/helper.dart';
import 'package:chess_flutter/models/BoardTheme.dart';
import 'package:chess_flutter/models/Piece.dart';
import 'package:chess_flutter/models/PieceSets.dart';
import 'package:chess_flutter/models/Square.dart';
import 'package:flutter/material.dart';

class ChessBoardUI extends StatefulWidget {
  final bool isFlipped;
  final void Function(
      {required int score,
      required bool turnOfWhite,
      required Map<String, String> move,
      required Piece? piece}) pressClock;

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
  // TODO: change the gameStatus when timer runs out

  void pieceSelected(int idx) {
    if (game.gameStatus == GameStatus.gameOver) return;
    setState(() {
      if (game.isSelectedSquare && game.legalMoves.contains(idx)) {
        widget.pressClock(
            score: game.score,
            turnOfWhite: !game.fen.turnOfWhite,
            move: {getSquareName(idx): game.fen.board[game.selectedSquare.idx].piece!.asset},
            piece: game.fen.board[idx].piece);
        game.makeMove(idx);
      } else if (game.fen.turnOfWhite == game.fen.board[idx].piece?.isWhitePiece) {
        game.setSelectedSquareIdx(idx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: AssetImage(myBoardTheme.boardAsset), fit: BoxFit.fill),
        AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
                itemCount: 64,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemBuilder: (context, index) {
                  bool isSelected = game.isSelectedSquare && game.selectedSquare.idx == index;
                  bool isValidMove = game.legalMoves.contains(index);

                  return DragTarget<Square>(onWillAcceptWithDetails: (detail) {
                    return isValidMove;
                  }, onAcceptWithDetails: (detail) {
                    pieceSelected(index);
                  }, builder: (context, candidateData, rejectedData) {
                    return SquareUI(
                        square: game.fen.board[index],
                        isSelected: isSelected,
                        isValidMove: isValidMove,
                        onTap: () => pieceSelected(index));
                  });
                })),
      ],
    );
  }
}

class SquareUI extends StatelessWidget {
  final Square square;
  final bool isSelected;
  final bool isValidMove;
  final void Function() onTap;

  const SquareUI(
      {super.key,
      required this.square,
      required this.isSelected,
      required this.isValidMove,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    var altColor = square.isWhiteSquare ? myBoardTheme.blackSquare : myBoardTheme.whiteSquare;
    double textFontSize = 12;
    var size = MediaQuery.of(context).size.width / 8;
    return GestureDetector(
        onTap: onTap,
        child: Container(
            color: isSelected ? myBoardTheme.selectedSquare : Colors.transparent,
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
                        feedback: Image.asset(
                          myPieceSet.path + square.piece!.asset,
                          fit: BoxFit.contain,
                          scale: 2,
                        ),
                        childWhenDragging: Image.asset(myPieceSet.path4x + square.piece!.asset,
                            opacity: const AlwaysStoppedAnimation(0.5), fit: BoxFit.cover),
                        child:
                            Image.asset(myPieceSet.path4x + square.piece!.asset, fit: BoxFit.fill)),
                  if (isValidMove)
                    // show legal move indicator
                    Container(
                        margin: square.piece != null
                            ? const EdgeInsets.all(1)
                            : EdgeInsets.all(size / 4),
                        decoration:
                            BoxDecoration(color: myBoardTheme.legalMove, shape: BoxShape.circle))
                ]))));
  }
}
