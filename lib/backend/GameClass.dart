import 'package:chess_flutter/backend/fen_handler.dart';
import 'package:chess_flutter/backend/helper.dart';
import 'package:chess_flutter/models/Square.dart';

import '../models/Move.dart';
import '../models/Piece.dart';

class Game {
  int score = 0;
  List<Move> moveHistory = [];
  List<int> legalMoves = [];
  bool isSelectedSquare = false;
  late FEN fen;
  late GameStatus gameStatus;
  late Square selectedSquare;
  late Piece selectedPiece;

// todo Board Representation -> https://en.wikipedia.org/wiki/Board_representation_(computer_chess)
// todo 3-fold repetition -> https://en.wikipedia.org/wiki/Board_representation_(computer_chess)#:~:text=Board%20representation%20typically,separate%20data%20structures.

  Game(String fenPosition) {
    gameStatus = GameStatus.inProgress;
    fen = FEN(fenPosition);
  }

  void setGameStatus(GameStatus status) {
    gameStatus = status;
  }

  void setSelectedSquareIdx(int idx) {
    isSelectedSquare = true;
    selectedSquare = fen.board[idx];
    if (isSelectedSquare == false || selectedSquare.piece == null) {
      legalMoves = [];
      isSelectedSquare = false;
      return;
    }
    selectedPiece = selectedSquare.piece!;
    _generateLegalMoves();
  }

  void _generateLegalMoves() {
    legalMoves = [];
    List<int> partialLegalMoves = [];

    // Generate legal moves
    switch (selectedPiece.name) {
      case PieceName.pawn:
        _generatePawnMoves(partialLegalMoves);
        break;
      case PieceName.knight:
        _generateKnightMoves(partialLegalMoves);
        break;
      case PieceName.bishop:
        _generateBishopMoves(partialLegalMoves);
        break;
      case PieceName.rook:
        _generateRookMoves(partialLegalMoves);
        break;
      case PieceName.queen:
        _generateQueenMoves(partialLegalMoves);
        break;
      case PieceName.king:
        _generateKingMoves(partialLegalMoves);
        break;
    }
    legalMoves = partialLegalMoves;
    _filterLegalMoves(partialLegalMoves);
  }

  void _filterLegalMoves(List<int> moves) {}

  void _generateKnightMoves(List<int> moves) {
    List<int> long = [2, -2];
    List<int> short = [1, -1];

    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        var rank = selectedSquare.rank + long[i];
        var file = selectedSquare.file + short[j];
        if (isOnBoard(rank, file)) {
          var targetIdx = file + rank * 8;
          if (fen.board[targetIdx].piece == null) {
            moves.add(targetIdx);
          } else {
            if (fen.board[targetIdx].piece!.isWhitePiece != selectedPiece.isWhitePiece) {
              moves.add(targetIdx);
            }
          }
        }
      }
    }

    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        var file = selectedSquare.file + long[i];
        var rank = selectedSquare.rank + short[j];
        if (isOnBoard(rank, file)) {
          var targetIdx = file + rank * 8;
          if (fen.board[targetIdx].piece == null) {
            moves.add(targetIdx);
          } else {
            if (fen.board[targetIdx].piece!.isWhitePiece != selectedPiece.isWhitePiece) {
              moves.add(targetIdx);
            }
          }
        }
      }
    }
  }

  void _generatePawnMoves(List<int> moves) {
    var direction = selectedPiece.isWhitePiece ? 1 : -1;
    List<int> offset = [1, -1, 8];

    // pawn can move 1 square forward if the square is empty
    var targetIdx = selectedSquare.idx + offset[2] * direction;
    if (isOnBoard(targetIdx) && fen.board[targetIdx].piece == null) {
      moves.add(targetIdx);

      // pawn can move 2 squares forward if it is in the starting position
      targetIdx = targetIdx + offset[2] * direction;
      if (selectedPiece.isWhitePiece && selectedSquare.rank == 1 ||
          !selectedPiece.isWhitePiece && selectedSquare.rank == 6) {
        if (fen.board[targetIdx].piece == null) {
          moves.add(targetIdx);
        }
      }
    }

    // pawn can capture diagonally
    for (int i = 0; i < 2; i++) {
      var rank = selectedSquare.rank + direction;
      var file = selectedSquare.file + offset[i];
      targetIdx = rank * 8 + file;
      if (isOnBoard(rank, file) && fen.board[targetIdx].piece != null) {
        var piece = fen.board[targetIdx].piece!;

        piece.isWhitePiece != selectedPiece.isWhitePiece ? moves.add(targetIdx) : null;
      }
    }

    // en-passant move
    if (fen.enPassantSquare != -1) {
      var square = fen.board[fen.enPassantSquare];
      if (square.rank == selectedSquare.rank && (square.file - selectedSquare.file).abs() == 1) {
        moves.add(square.idx + 8 * direction);
      }
    }
  }

  void _generateBishopMoves(List<int> moves) {
    List<int> offset = [-1, 1];
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        var rank = selectedSquare.rank + offset[i];
        var file = selectedSquare.file + offset[j];
        if (isOnBoard(rank, file)) {
          var targetIdx = rank * 8 + file;
          while (isOnBoard(rank, file)) {
            if (fen.board[targetIdx].piece == null) {
              moves.add(targetIdx);
            } else {
              if (fen.board[targetIdx].piece!.isWhitePiece != selectedPiece.isWhitePiece) {
                moves.add(targetIdx);
              }
              break;
            }
            rank += offset[i];
            file += offset[j];
            targetIdx = rank * 8 + file;
          }
        }
      }
    }
  }

  void _generateKingMoves(List<int> moves) {
    List<int> arr = [0, 1, -1];
    for (int i = 0; i < arr.length; i++) {
      for (int j = 0; j < arr.length; j++) {
        var rank = selectedSquare.rank + arr[i];
        var file = selectedSquare.file + arr[j];
        var targetIdx = file + rank * 8;
        if (isOnBoard(rank, file)) {
          if (fen.board[targetIdx].piece == null) {
            moves.add(targetIdx);
          } else {
            if (fen.board[targetIdx].piece!.isWhitePiece != selectedPiece.isWhitePiece) {
              moves.add(targetIdx);
            }
          }
        }
      }
    }

    // Queen side Castling
    bool queenSideCastle = fen.turnOfWhite ? fen.whiteQueenSideCastle : fen.blackQueenSideCastle;
    if (queenSideCastle) {
      bool pathClear = true;
      int rookIdx = selectedSquare.idx - 4;
      if (fen.board[rookIdx].piece!.name == PieceName.rook) {
        for (int i = rookIdx + 1; i < selectedSquare.idx; i++) {
          if (fen.board[i].piece != null) {
            pathClear = false;
            break;
          }
        }
        if (pathClear) moves.add(selectedSquare.idx - 2);
      } else {
        if (fen.turnOfWhite) {
          fen.whiteQueenSideCastle = false;
        } else {
          fen.blackQueenSideCastle = false;
        }
      }
    }

    // King side Castling
    bool kingSideCastle = fen.turnOfWhite ? fen.whiteKingSideCastle : fen.blackKingSideCastle;
    if (kingSideCastle) {
      bool pathClear = true;
      int rookIdx = selectedSquare.idx + 3;
      var rookPiece = fen.board[rookIdx].piece;
      if (rookPiece != null && rookPiece.name == PieceName.rook) {
        for (int idx = selectedSquare.idx + 1; idx < rookIdx; idx++) {
          if (fen.board[idx].piece != null) {
            pathClear = false;
            break;
          }
        }
        if (pathClear) moves.add(selectedSquare.idx + 2);
      } else {
        if (fen.turnOfWhite) {
          fen.whiteKingSideCastle = false;
        } else {
          fen.blackKingSideCastle = false;
        }
      }
    }
  }

  void _generateQueenMoves(List<int> moves) {
    _generateBishopMoves(moves);
    _generateRookMoves(moves);
  }

  void _generateRookMoves(List<int> moves) {
    List<int> arr = [-1, 1];

    // Vertical Moves
    for (int i = 0; i < 2; i++) {
      var direction = arr[i];
      var rank = selectedSquare.rank + direction;
      var file = selectedSquare.file;
      while (isOnBoard(rank, file)) {
        var targetIdx = file + rank * 8;
        if (fen.board[targetIdx].piece == null) {
          moves.add(targetIdx);
        } else {
          if (fen.board[targetIdx].piece!.isWhitePiece != selectedPiece.isWhitePiece) {
            moves.add(targetIdx);
          }
          break;
        }
        rank = rank + direction;
      }
    }
    // Horizontal Moves

    for (int i = 0; i < 2; i++) {
      var direction = arr[i];
      var rank = selectedSquare.rank;
      var file = selectedSquare.file + direction;
      while (isOnBoard(rank, file)) {
        var targetIdx = file + rank * 8;
        if (fen.board[targetIdx].piece == null) {
          moves.add(targetIdx);
        } else {
          if (fen.board[targetIdx].piece!.isWhitePiece != selectedPiece.isWhitePiece) {
            moves.add(targetIdx);
          }
          break;
        }
        file = file + direction;
      }
    }
  }

  bool isOnBoard(int idx, [int? file]) {
    if (file == null) return idx >= 0 && idx < 64;
    return idx >= 0 && idx < 8 && file >= 0 && file < 8;
  }

  void makeMove(int targetIdx) async {
    legalMoves = [];
    moveHistory.add(Move(selectedSquare.idx, targetIdx));

    var capturedPiece = fen.board[targetIdx].piece;
    // check if the move is a capture
    if (capturedPiece != null) {
      fen.halfMoveClock = 0;
      score += capturedPiece.value;
    }

    switch (selectedPiece.name) {
      case PieceName.king:
        {
          if (fen.turnOfWhite) {
            fen.whiteKingSideCastle = false;
            fen.whiteQueenSideCastle = false;
          } else {
            fen.blackKingSideCastle = false;
            fen.blackQueenSideCastle = false;
          }
          if ((selectedSquare.idx - targetIdx).abs() == 2) {
            int rookIdx = targetIdx + (targetIdx > selectedSquare.idx ? -1 : 1);
            int currRookIdx = targetIdx + (targetIdx > selectedSquare.idx ? 1 : -2);
            fen.board[rookIdx].piece = fen.board[currRookIdx].piece;
            fen.board[currRookIdx].piece = null;
          }
        }
      case PieceName.pawn:
        {
          fen.halfMoveClock = 0;

          // update en-passant square
          if ((targetIdx - selectedSquare.idx).abs() == 16) {
            fen.enPassantSquare = targetIdx;
          }
          // make en-passant move
          else if (fen.enPassantSquare != -1 && (targetIdx - fen.enPassantSquare).abs() == 8) {
            // capture en-passant piece
            score += fen.board[fen.enPassantSquare].piece!.value;
            fen.board[fen.enPassantSquare].piece = null;
            fen.enPassantSquare = -1;
          } else {
            fen.enPassantSquare = -1;
            bool isLastRankForWhite = fen.turnOfWhite && targetIdx > 55;
            bool isLastRankForBlack = !fen.turnOfWhite && targetIdx < 8;
            if (isLastRankForWhite || isLastRankForBlack) {
              var promotionPiece = Piece(PieceName.queen, fen.turnOfWhite);
              score -= promotionPiece.value + selectedPiece.value;
              selectedPiece = promotionPiece;
            }
          }
        }
      case PieceName.rook:
        {
          bool isKingSide = selectedSquare.idx % 8 != 0;
          if (fen.turnOfWhite) {
            if (fen.whiteKingSideCastle) fen.whiteKingSideCastle &= !isKingSide;
            if (fen.whiteQueenSideCastle) {
              fen.whiteQueenSideCastle &= isKingSide;
            }
          } else {
            if (fen.blackKingSideCastle) fen.blackKingSideCastle &= !isKingSide;
            if (fen.blackQueenSideCastle) {
              fen.blackQueenSideCastle &= isKingSide;
            }
          }
        }
      default:
        {}
    }

    // update the board
    if (selectedPiece.name != PieceName.pawn) {
      fen.enPassantSquare = -1;
    }
    fen.turnOfWhite = !fen.turnOfWhite;
    if (fen.turnOfWhite) fen.fullMoveNumber++;
    fen.halfMoveClock++;

    fen.board[selectedSquare.idx].piece = null;
    fen.board[targetIdx].piece = selectedPiece;

    // check if the move is a promotion move

    // check if the move is a checkmate move

    // check if the move is a stalemate move

    // check if the move is a draw move

    // check if the move is a check move
  }
}
