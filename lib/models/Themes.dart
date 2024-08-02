import 'package:flutter/material.dart';

class AppTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor1;
  final Color accentColor2;

  AppTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor1,
    required this.accentColor2,
  });
}

final appColors1 = AppTheme(
    primaryColor: const Color(0xFF564B8F),
    secondaryColor: const Color(0xFF303A53),
    accentColor1: const Color(0xFFFC85AD),
    accentColor2: const Color(0xFF9E579D));

final appColors2 = AppTheme(
    primaryColor: const Color(0xFF84587C),
    secondaryColor: const Color(0xFF333645),
    accentColor1: const Color(0xFFF7E1B8),
    accentColor2: const Color(0xFFC65F63));

class GameTheme {
  final Color whiteSquare;
  final Color blackSquare;
  final Color selectedSquare;
  final Color legalMove;
  final Color checkSquare;
  final Color lastMove;
  final Color promotionSquare;
  final Color promotionPiece;

  GameTheme({
    required this.whiteSquare,
    required this.blackSquare,
    required this.selectedSquare,
    required this.legalMove,
    required this.checkSquare,
    required this.lastMove,
    required this.promotionSquare,
    required this.promotionPiece,
  });
}

final defaultTheme = GameTheme(
    whiteSquare: const Color(0xFFEAD2AC),
    blackSquare: const Color(0xFFB58B7F),
    selectedSquare: const Color(0xFFC65F63),
    legalMove: const Color(0xFF9E579D).withOpacity(0.5),
    checkSquare: const Color(0xFFFC85AD),
    lastMove: const Color(0xFF564B8F),
    promotionSquare: const Color(0xFFFC85AD),
    promotionPiece: const Color(0xFF9E579D));

final lichessTheme2 = GameTheme(
    whiteSquare: const Color(0xFFF3F3F3),
    blackSquare: const Color(0xFF7D7D7D),
    selectedSquare: const Color(0xFF0074CC),
    legalMove: const Color(0xFF00CC00).withOpacity(0.5),
    checkSquare: const Color(0xFFFF4500),
    lastMove: const Color(0xFF00CC00),
    promotionSquare: const Color(0xFF00CED1),
    promotionPiece: const Color(0xFF4682B4));

final chessComTheme1 = GameTheme(
    whiteSquare: const Color(0xFFEEEED2),
    blackSquare: const Color(0xFF769656),
    selectedSquare: const Color(0xFFBACA44),
    legalMove: const Color(0xFF58AC8A).withOpacity(0.5),
    checkSquare: const Color(0xFFE73D1F),
    lastMove: const Color(0xFFAFCBC4),
    promotionSquare: const Color(0xFFDCF5E3),
    promotionPiece: const Color(0xFF5CAFB4));

final chessComTheme2 = GameTheme(
    whiteSquare: const Color(0xFFF0D9B5),
    blackSquare: const Color(0xFFB58863),
    selectedSquare: const Color(0xFF9D9D9D),
    legalMove: const Color(0xFF1ABC9C).withOpacity(0.5),
    checkSquare: const Color(0xFFE74C3C),
    lastMove: const Color(0xFF1ABC9C),
    promotionSquare: const Color(0xFFF1C40F),
    promotionPiece: const Color(0xFF2980B9));
