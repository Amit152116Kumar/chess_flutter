import 'package:chess_flutter/models/Themes.dart';
import 'package:chess_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chess',
        theme: ThemeData(
            scaffoldBackgroundColor: appTheme.secondaryColor,
            appBarTheme: AppBarTheme(
                color: appTheme.primaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: appTheme.secondaryColor,
                selectedItemColor: appTheme.accentColor1,
                unselectedItemColor: appTheme.accentColor2)),
        home: const HomeScreen(title: 'Flutter Chess'),
        debugShowCheckedModeBanner: false);
  }
}

final AppTheme appTheme = appColors2;
//
// final ThemeData chessThemeData = ThemeData(
//   primarySwatch: Colors.deepPurple,
//   primaryColor: appTheme.primaryColor,
//   hintColor: appTheme.accentColor1,
//   secondaryHeaderColor: appTheme.secondaryColor,
//   scaffoldBackgroundColor: appTheme.secondaryColor,
//   appBarTheme: AppBarTheme(
//     color: appTheme.primaryColor,
//     iconTheme: IconThemeData(color: appTheme.accentColor1),
//     toolbarTextStyle: TextStyle(
//       color: appTheme.accentColor1,
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//     ),
//     titleTextStyle: TextStyle(
//       color: appTheme.accentColor1,
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   buttonTheme: ButtonThemeData(
//     buttonColor: appTheme.accentColor1,
//     textTheme: ButtonTextTheme.primary,
//   ),
//   cardColor: appTheme.primaryColor,
//   iconTheme: IconThemeData(color: appTheme.accentColor2),
//   colorScheme: ColorScheme(
//     primary: appTheme.primaryColor,
//     secondary: appTheme.secondaryColor,
//     surface: appTheme.primaryColor,
//     background: appTheme.secondaryColor,
//     error: Colors.red,
//     onPrimary: Colors.white,
//     onSecondary: Colors.white,
//     onSurface: Colors.white,
//     onBackground: appTheme.accentColor2,
//     onError: Colors.white,
//     brightness: Brightness.dark,
//   ),
// );
