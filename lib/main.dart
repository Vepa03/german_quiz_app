import 'package:flutter/material.dart';
import 'package:german_quiz_app/pages/HomePage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.white),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        cardTheme: CardThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black
        ),
      ),
      home: HomePage()
    );
  }
}
