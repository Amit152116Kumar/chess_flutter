import 'dart:ui';

class AppTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor1;
  final Color accentColor2;

  AppTheme(
      {required this.primaryColor,
      required this.secondaryColor,
      required this.accentColor1,
      required this.accentColor2});
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
