import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool sound = true;
  bool confirmEachMove = false;
  bool autoQueen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(children: [
          ListTile(
              title: const Text('Sound'),
              trailing: Switch(
                  value: sound,
                  onChanged: (value) {
                    setState(() {
                      sound = value;
                    });
                  })),
          ListTile(
              title: const Text('Confirm Each Move'),
              trailing: Switch(
                  value: confirmEachMove,
                  onChanged: (value) {
                    setState(() {
                      confirmEachMove = value;
                    });
                  })),
          ListTile(
              title: const Text('Auto-Queen'),
              trailing: Switch(
                  value: autoQueen,
                  onChanged: (value) {
                    setState(() {
                      autoQueen = value;
                    });
                  }))
        ]));
  }
}
