import 'package:flutter/material.dart';
import 'package:german_quiz_app/pages/ChatBot.dart';
import 'package:german_quiz_app/pages/Main.dart';
import 'package:german_quiz_app/pages/Questions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> pages = const[
    Main(),
    CategoriesPage(),
    Chatbot(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset("assets/images/logo.png"),
        ),
        title: Text("Quiz"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bookOpen), label: 'Questions'),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.robot), label: 'ChatBot'),
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      )

    );
  }
}