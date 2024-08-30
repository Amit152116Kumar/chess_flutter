import 'package:flutter/material.dart';

class GameTheme {
  final String boardAsset;
  final Color whiteSquare;
  final Color blackSquare;
  final Color selectedSquare;
  final Color legalMove;
  final Color checkSquare;
  final Color lastMove;
  final Color promotionSquare;
  final Color promotionPiece;

  GameTheme(
      {required this.boardAsset,
      required this.whiteSquare,
      required this.blackSquare,
      required this.selectedSquare,
      required this.legalMove,
      required this.checkSquare,
      required this.lastMove,
      required this.promotionSquare,
      required this.promotionPiece});
}

GameTheme myBoardTheme = blue2;

List<GameTheme> boardThemes = [
  blue2,
  blue3,
  green,
  leather,
  maple,
  maple2,
  metal,
  newspaper,
  ncfBoard,
  pinkPyramid,
  purple,
  wood,
];
final blue2 = GameTheme(
  boardAsset: "assets/boards/blue2.jpg",
  whiteSquare: const Color(0xFFD0D9DC),
  blackSquare: const Color(0xFF819CA3),
  selectedSquare: const Color(0xFF78909C),
  legalMove: const Color(0xFFB0BEC5).withOpacity(0.5),
  checkSquare: const Color(0xFFEF5350),
  lastMove: const Color(0xFF90A4AE),
  promotionSquare: const Color(0xFF607D8B),
  promotionPiece: const Color(0xFFCFD8DC),
);

final blue3 = GameTheme(
    boardAsset: "assets/boards/blue3.jpg",
    whiteSquare: const Color(0xFFD2D9E1),
    blackSquare: const Color(0xFF76ADCB),
    selectedSquare: const Color(0xFF0074CC),
    legalMove: const Color(0xFF00CC00).withOpacity(0.5),
    checkSquare: const Color(0xFFFF4500),
    lastMove: const Color(0xFF00CC00),
    promotionSquare: const Color(0xFF00CED1),
    promotionPiece: const Color(0xFF4682B4));

final metal = GameTheme(
    boardAsset: "assets/boards/metal.jpg",
    whiteSquare: const Color(0xFFBBBBBB),
    blackSquare: const Color(0xFF959595),
    selectedSquare: const Color(0xFFBACA44),
    legalMove: const Color(0xFF58AC8A).withOpacity(0.5),
    checkSquare: const Color(0xFFE73D1F),
    lastMove: const Color(0xFFAFCBC4),
    promotionSquare: const Color(0xFFDCF5E3),
    promotionPiece: const Color(0xFF5CAFB4));

final wood = GameTheme(
    boardAsset: "assets/boards/wood.jpg",
    whiteSquare: const Color(0xFFD0D9DC),
    blackSquare: const Color(0xFF819CA3),
    selectedSquare: const Color(0xFF9D9D9D),
    legalMove: const Color(0xFF1ABC9C).withOpacity(0.5),
    checkSquare: const Color(0xFFE74C3C),
    lastMove: const Color(0xFF1ABC9C),
    promotionSquare: const Color(0xFFF1C40F),
    promotionPiece: const Color(0xFF2980B9));

final green = GameTheme(
  boardAsset: "assets/boards/green-plastic.png",
  whiteSquare: const Color(0xFFD2D9E1),
  blackSquare: const Color(0xFF76ADCB),
  selectedSquare: const Color(0xFF0074CC),
  legalMove: const Color(0xFF00CC00).withOpacity(0.5),
  checkSquare: const Color(0xFFFF4500),
  lastMove: const Color(0xFF00CC00),
  promotionSquare: const Color(0xFF00CED1),
  promotionPiece: const Color(0xFF4682B4),
);

final leather = GameTheme(
  boardAsset: "assets/boards/leather.jpg",
  whiteSquare: const Color(0xFFBBBBBB),
  blackSquare: const Color(0xFF959595),
  selectedSquare: const Color(0xFFBACA44),
  legalMove: const Color(0xFF58AC8A).withOpacity(0.5),
  checkSquare: const Color(0xFFE73D1F),
  lastMove: const Color(0xFFAFCBC4),
  promotionSquare: const Color(0xFFDCF5E3),
  promotionPiece: const Color(0xFF5CAFB4),
);

final maple = GameTheme(
  boardAsset: "assets/boards/maple.jpg",
  whiteSquare: const Color(0xFFD0D9DC),
  blackSquare: const Color(0xFF819CA3),
  selectedSquare: const Color(0xFF9D9D9D),
  legalMove: const Color(0xFF1ABC9C).withOpacity(0.5),
  checkSquare: const Color(0xFFE74C3C),
  lastMove: const Color(0xFF1ABC9C),
  promotionSquare: const Color(0xFFF1C40F),
  promotionPiece: const Color(0xFF2980B9),
);

final maple2 = GameTheme(
  boardAsset: "assets/boards/maple2.jpg",
  whiteSquare: const Color(0xFFD2D9E1),
  blackSquare: const Color(0xFF76ADCB),
  selectedSquare: const Color(0xFF0074CC),
  legalMove: const Color(0xFF00CC00).withOpacity(0.5),
  checkSquare: const Color(0xFFFF4500),
  lastMove: const Color(0xFF00CC00),
  promotionSquare: const Color(0xFF00CED1),
  promotionPiece: const Color(0xFF4682B4),
);

final newspaper = GameTheme(
  boardAsset: "assets/boards/newspaper.png",
  whiteSquare: const Color(0xFFBBBBBB),
  blackSquare: const Color(0xFF959595),
  selectedSquare: const Color(0xFFBACA44),
  legalMove: const Color(0xFF58AC8A).withOpacity(0.5),
  checkSquare: const Color(0xFFE73D1F),
  lastMove: const Color(0xFFAFCBC4),
  promotionSquare: const Color(0xFFDCF5E3),
  promotionPiece: const Color(0xFF5CAFB4),
);

final ncfBoard = GameTheme(
  boardAsset: "assets/boards/ncf-board.png",
  whiteSquare: const Color(0xFFD0D9DC),
  blackSquare: const Color(0xFF819CA3),
  selectedSquare: const Color(0xFF9D9D9D),
  legalMove: const Color(0xFF1ABC9C).withOpacity(0.5),
  checkSquare: const Color(0xFFE74C3C),
  lastMove: const Color(0xFF1ABC9C),
  promotionSquare: const Color(0xFFF1C40F),
  promotionPiece: const Color(0xFF2980B9),
);

final pinkPyramid = GameTheme(
  boardAsset: "assets/boards/pink-pyramid.png",
  whiteSquare: const Color(0xFFD2D9E1),
  blackSquare: const Color(0xFF76ADCB),
  selectedSquare: const Color(0xFF0074CC),
  legalMove: const Color(0xFF00CC00).withOpacity(0.5),
  checkSquare: const Color(0xFFFF4500),
  lastMove: const Color(0xFF00CC00),
  promotionSquare: const Color(0xFF00CED1),
  promotionPiece: const Color(0xFF4682B4),
);

final purple = GameTheme(
  boardAsset: "assets/boards/purple.png",
  whiteSquare: const Color(0xFFD0D9DC),
  blackSquare: const Color(0xFF819CA3),
  selectedSquare: const Color(0xFF9D9D9D),
  legalMove: const Color(0xFF1ABC9C).withOpacity(0.5),
  checkSquare: const Color(0xFFE74C3C),
  lastMove: const Color(0xFF1ABC9C),
  promotionSquare: const Color(0xFFF1C40F),
  promotionPiece: const Color(0xFF2980B9),
);
