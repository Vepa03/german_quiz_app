import 'package:flutter/material.dart';
import 'package:german_quiz_app/pages/Completed.dart';
import 'package:german_quiz_app/pages/Main.dart';
import 'package:german_quiz_app/pages/Questions.dart';
import 'package:german_quiz_app/pages/Settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Main(),
    Questions(),
    Completed()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset("assets/images/logo.png"),
        ),
        title: Text("Quiz"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Settings()));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Icon(Icons.settings_outlined,  size: width*0.07,),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

    );
  }
}