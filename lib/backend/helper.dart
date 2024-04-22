
enum PieceName { king, queen, bishop, knight, rook, pawn }

enum GameStatus {
  inProgress,
  whiteWon,
  blackWon,
  draw,
  stalemate,
}

const startFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

Map<PieceName, int> pieceValue = {
  PieceName.king: 0,
  PieceName.queen: 9,
  PieceName.rook: 5,
  PieceName.bishop: 3,
  PieceName.knight: 3,
  PieceName.pawn: 1,
};

//file => a-h; file
//rank => 1-8; row
//idx => 0-63; index

Map<String, PieceName> pieceMap = {
  'r': PieceName.rook,
  'n': PieceName.knight,
  'k': PieceName.king,
  'b': PieceName.bishop,
  'q': PieceName.queen,
  'p': PieceName.pawn,
};

class Piece {
  final PieceName name;
  final bool isWhitePiece;
  final String asset;
  final int value;

  Piece(this.name, this.isWhitePiece)
      : asset = "assets/images/${isWhitePiece ? 'white' : 'black'}_${name.toString().split('.').last}.png",
        value = pieceValue[name]! * (isWhitePiece ? -1 : 1);

}

class Move {
  final int from;
  final int to;

  const Move(this.from, this.to);
}