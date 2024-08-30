import 'package:chess_flutter/backend/helper.dart';

class Piece {
  final PieceName name;
  final bool isWhitePiece;
  final String asset;
  final int value;
  late List<int> attackSquares = [];

  Piece(this.name, this.isWhitePiece)
      : asset =
            "${isWhitePiece ? 'w' : 'b'}${pieceMap.keys.firstWhere((k) => pieceMap[k] == name).toUpperCase()}"
                ".png",
        value = pieceValue[name]! * (isWhitePiece ? -1 : 1);
}
