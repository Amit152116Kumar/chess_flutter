import 'package:chess_flutter/backend/SquareClass.dart';
import 'package:chess_flutter/backend/fen_handler.dart';
import 'package:chess_flutter/backend/helper.dart';

class Game {
  int score = 0;
  List<Move> moveHistory = [];
  List<int> legalMoves = [];
  bool isSelectedSquare = false;
  late FEN fen;
  late GameStatus gameStatus;
  late Square selectedSquare;
  late Piece selectedPiece;
  final List<int> offsets = [-1, 1, -8, 8, -7, 7, -9, 9];

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
    // Generate legal moves

    switch (selectedPiece.name) {
      case PieceName.pawn:
        _generatePawnMoves();
        break;
      case PieceName.knight:
        _generateKnightMoves();
        break;
      case PieceName.bishop:
        _generateBishopMoves();
        break;
      case PieceName.rook:
        _generateRookMoves();
        break;
      case PieceName.queen:
        _generateQueenMoves();
        break;
      case PieceName.king:
        _generateKingMoves();
        break;
    }
  }

  void _generateKnightMoves() {
    List<int> long = [2, -2];
    List<int> short = [1, -1];

    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        var rank = selectedSquare.rank + long[i];
        var file = selectedSquare.file + short[j];
        if (isOnBoard(rank, file)) {
          var targetSquare = file + rank * 8;
          if (fen.board[targetSquare].piece == null) {
            legalMoves.add(targetSquare);
          } else {
            if (fen.board[targetSquare].piece!.isWhitePiece !=
                selectedPiece.isWhitePiece) {
              legalMoves.add(targetSquare);
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
          var targetSquare = file + rank * 8;
          if (fen.board[targetSquare].piece == null) {
            legalMoves.add(targetSquare);
          } else {
            if (fen.board[targetSquare].piece!.isWhitePiece !=
                selectedPiece.isWhitePiece) {
              legalMoves.add(targetSquare);
            }
          }
        }
      }
    }
  }

  void _generatePawnMoves() {
    var direction = selectedPiece.isWhitePiece ? 1 : -1;

    // pawn can move 1 square forward if the square is empty
    var targetSquare = selectedSquare.idx + offsets[3] * direction;
    if (isOnBoard(targetSquare) && fen.board[targetSquare].piece == null) {
      legalMoves.add(targetSquare);

      // pawn can move 2 squares forward if it is in the starting position
      targetSquare = targetSquare + offsets[3] * direction;
      if (selectedPiece.isWhitePiece && selectedSquare.rank == 1 ||
          !selectedPiece.isWhitePiece && selectedSquare.rank == 6) {
        if (fen.board[targetSquare].piece == null) {
          legalMoves.add(targetSquare);
        }
      }
    }

    // pawn can capture diagonally
    for (int i = 0; i < 2; i++) {
      var rank = selectedSquare.rank + direction;
      var file = selectedSquare.file + offsets[i];
      targetSquare = rank * 8 + file;
      if (isOnBoard(rank, file) && fen.board[targetSquare].piece != null) {
        var piece = fen.board[targetSquare].piece!;

        piece.isWhitePiece != selectedPiece.isWhitePiece
            ? legalMoves.add(targetSquare)
            : null;
      }
    }

    // en-passant move
    if (fen.enPassantSquare != -1) {
      var square = fen.board[fen.enPassantSquare];
      if (square.rank == selectedSquare.rank &&
          (square.file - selectedSquare.file).abs() == 1) {
        legalMoves.add(square.idx + 8 * direction);
      }
    }
  }

  void _generateBishopMoves() {
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        var rank = selectedSquare.rank + offsets[i];
        var file = selectedSquare.file + offsets[j];
        if (isOnBoard(rank, file)) {
          var targetSquare = rank * 8 + file;
          while (isOnBoard(rank, file)) {
            if (fen.board[targetSquare].piece == null) {
              legalMoves.add(targetSquare);
            } else {
              if (fen.board[targetSquare].piece!.isWhitePiece !=
                  selectedPiece.isWhitePiece) {
                legalMoves.add(targetSquare);
              }
              break;
            }
            rank += offsets[i];
            file += offsets[j];
            targetSquare = rank * 8 + file;
          }
        }
      }
    }
  }

  void _generateKingMoves() {
    List<int> arr = [0, 1, -1];
    for (int i = 0; i < arr.length; i++) {
      for (int j = 0; j < arr.length; j++) {
        var rank = selectedSquare.rank + arr[i];
        var file = selectedSquare.file + arr[j];
        var targetSquare = file + rank * 8;
        if (rank >= 0 && rank < 8 && file >= 0 && file < 8) {
          if (fen.board[targetSquare].piece == null) {
            legalMoves.add(targetSquare);
          } else {
            if (fen.board[targetSquare].piece!.isWhitePiece !=
                selectedPiece.isWhitePiece) {
              legalMoves.add(targetSquare);
            }
          }
        }
      }
    }
  }

  void _generateQueenMoves() {
    _generateBishopMoves();
    _generateRookMoves();
  }

  void _generateRookMoves() {
    List<int> arr = [-1, 1];

    // Vertical Moves
    for (int i = 0; i < 2; i++) {
      var direction = arr[i];
      var rank = selectedSquare.rank + direction;
      var file = selectedSquare.file;
      while (isOnBoard(rank, file)) {
        var targetSquare = file + rank * 8;
        if (fen.board[targetSquare].piece == null) {
          legalMoves.add(targetSquare);
        } else {
          if (fen.board[targetSquare].piece!.isWhitePiece !=
              selectedPiece.isWhitePiece) {
            legalMoves.add(targetSquare);
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
        var targetSquare = file + rank * 8;
        if (fen.board[targetSquare].piece == null) {
          legalMoves.add(targetSquare);
        } else {
          if (fen.board[targetSquare].piece!.isWhitePiece !=
              selectedPiece.isWhitePiece) {
            legalMoves.add(targetSquare);
          }
          break;
        }
        file = file + direction;
      }
    }
  }

  bool isWrapped(int rank, int file) {
    if ((rank - selectedSquare.rank).abs() > 2 ||
        (file - selectedSquare.file) > 2) return true;
    return false;
  }

  bool isOnBoard(int idx, [int? file]) {
    if (file == null) return idx >= 0 && idx < 64;
    return idx >= 0 && idx < 8 && file >= 0 && file < 8;
  }

  bool isSameFile(int a, int b) {
    if (a % 8 == b % 8) return true;
    return false;
  }

  bool isSameRank(int a, int b) {
    if (a / 8 == b / 8) return true;
    return false;
  }

  void makeMove(int targetSquare) {
    legalMoves = [];
    moveHistory.add(Move(selectedSquare.idx, targetSquare));
    fen.turnOfWhite = !fen.turnOfWhite;
    if (fen.turnOfWhite) fen.fullMoveNumber++;
    fen.halfMoveClock++;

    var capturedPiece = fen.board[targetSquare].piece;

    // check if the move is a capture
    if (capturedPiece != null) {
      fen.halfMoveClock = 0;
      score += capturedPiece.value;
    }
    // check if the move is a pawn move
    if (selectedPiece.name == PieceName.pawn) {
      fen.halfMoveClock = 0;

      // update en-passant square
      if ((targetSquare - selectedSquare.idx).abs() == 16) {
        fen.enPassantSquare = targetSquare;
      }
      //
      else if (fen.enPassantSquare != -1 &&
          (targetSquare - fen.enPassantSquare).abs() == 8) {
        // capture en-passant piece
        score += fen.board[fen.enPassantSquare].piece!.value;
        fen.board[fen.enPassantSquare].piece = null;
        fen.enPassantSquare = -1;
      }
    } else {
      fen.enPassantSquare = -1;
    }
    // update the board
    fen.board[selectedSquare.idx].piece = null;
    fen.board[targetSquare].piece = selectedPiece;

    // check if the move is a castling move

    // check if the move is a promotion move

    // check if the move is a checkmate move

    // check if the move is a stalemate move

    // check if the move is a draw move

    // check if the move is a check move

    // check if the move is a checkmate move
  }
}
