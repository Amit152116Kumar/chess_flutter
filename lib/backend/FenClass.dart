import 'package:chess_flutter/backend/helper.dart';
import 'package:chess_flutter/models/Piece.dart';
import 'package:chess_flutter/models/Square.dart';
import 'package:flutter/foundation.dart';

class FEN {
  late List<Square> board;
  late bool turnOfWhite; // white or black
  late int enPassantSquare; // square index
  late bool whiteKingSideCastle; // can white king side castle
  late bool whiteQueenSideCastle; // can white queen side castle
  late bool blackKingSideCastle; // can black king side castle
  late bool blackQueenSideCastle; // can black queen side castle
  late int halfMoveClock; // no of half moves without capture or pawn advance
  late int fullMoveNumber; // starts at 1, incremented after black

  FEN(String fenPosition) {
    List rule = fenPosition.split(' ');
    board = getBoardPosition(rule[0]);
    turnOfWhite = rule[1] == 'w' ? true : false;
    enPassantSquare = rule[3] != '-' ? getSquareIdx(rule[3]) : -1;
    whiteKingSideCastle = rule[2].contains('K');
    whiteQueenSideCastle = rule[2].contains('Q');
    blackKingSideCastle = rule[2].contains('k');
    blackQueenSideCastle = rule[2].contains('q');
    halfMoveClock = int.parse(rule[4]);
    fullMoveNumber = int.parse(rule[5]);
  }

  FEN copy() {
    FEN newFEN = FEN(getFEN());
    return newFEN;
  }

  List<Square> getBoardPosition(String fenPosition) {
    List<Square> board = [];
    int rank = 7;
    int file = 0;

    for (int i = 0; i < fenPosition.length; i++) {
      // Convert the char to Ascii value
      int char = fenPosition[i].codeUnits[0];
      // check '/'
      if (char == 47) {
        file = 0;
        rank--;
      }
      // check number
      else if (char > 48 && char < 57) {
        int emptyRow = char - 48;
        while (emptyRow != 0) {
          board.add(Square(rank, file));
          file++;
          emptyRow--;
        }
      } else {
        PieceName piece = pieceMap[fenPosition[i].toLowerCase()]!;
        // check Upper case char
        if (char > 64 && char < 90) {
          board.add(Square(rank, file, piece: Piece(piece, true)));
        }
        // check lower case char
        else {
          board.add(Square(rank, file, piece: Piece(piece, false)));
        }
        file++;
      }
    }
    mergeSort(board);
    return board;
  }

  String getFEN() {
    String fen = '';
    int emptySquare = 0;
    for (int i = 0; i < 64; i++) {
      if (i % 8 == 0 && i != 0) {
        if (emptySquare != 0) {
          fen += emptySquare.toString();
          emptySquare = 0;
        }
        fen += '/';
      }
      if (board[i].piece == null) {
        emptySquare++;
      } else {
        if (emptySquare != 0) {
          fen += emptySquare.toString();
          emptySquare = 0;
        }
        fen += board[i].piece!.isWhitePiece
            ? board[i].piece!.name.toString().toUpperCase()[0]
            : board[i].piece!.name.toString().toLowerCase()[0];
      }
    }
    if (emptySquare != 0) {
      fen += emptySquare.toString();
    }
    fen += ' ';
    fen += turnOfWhite ? 'w' : 'b';
    fen += ' ';
    fen += whiteKingSideCastle ? 'K' : '';
    fen += whiteQueenSideCastle ? 'Q' : '';
    fen += blackKingSideCastle ? 'k' : '';
    fen += blackQueenSideCastle ? 'q' : '';
    fen += ' ';
    fen += enPassantSquare == -1 ? '-' : getSquareName(enPassantSquare);
    fen += ' ';
    fen += halfMoveClock.toString();
    fen += ' ';
    fen += fullMoveNumber.toString();
    return fen;
  }
}
