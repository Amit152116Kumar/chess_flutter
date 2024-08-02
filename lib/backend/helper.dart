enum PieceName { king, queen, bishop, knight, rook, pawn }

enum GameStatus {
  inProgress,
  gameOver,
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
