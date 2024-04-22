
import 'package:flutter/material.dart';

import 'game_screen.dart';
import 'widget/main_widget.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key,required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIdx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.grey.shade600,
        foregroundColor:  Colors.blueGrey.shade900,
        shadowColor: Colors.grey.shade300,
      ),
      body: Container(
        color: Colors.grey.shade700,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoundedButton(title: "Play Online",onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> GameScreen()));
            }),
            RoundedButton(title: "Play Offline",onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> GameScreen()));
            })
          ],
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        currentIndex: tabIdx,
        onTap: _setTabIdx,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }

  void _setTabIdx(int index){
    setState(() {
      tabIdx = index;
    });
  }
}
