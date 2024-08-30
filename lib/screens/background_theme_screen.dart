import 'package:flutter/material.dart';

class BackgroundThemeScreen extends StatefulWidget {
  const BackgroundThemeScreen({super.key});

  @override
  State<BackgroundThemeScreen> createState() => _BackgroundThemeScreenState();
}

class _BackgroundThemeScreenState extends State<BackgroundThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Theme'),
      ),
      body: Placeholder(),
    );
  }
}
