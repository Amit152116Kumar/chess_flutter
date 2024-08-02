import '../backend/helper.dart';

class Piece {
  final PieceName name;
  final bool isWhitePiece;
  final String asset;
  final int value;

  Piece(this.name, this.isWhitePiece)
      : asset =
            "assets/images/${isWhitePiece ? 'white' : 'black'}_${name.toString().split('.').last}.png",
        value = pieceValue[name]! * (isWhitePiece ? -1 : 1);
}
