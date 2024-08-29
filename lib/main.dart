import 'package:flutter/material.dart';
import 'package:wordle_project/wordle_game.dart';
import 'package:wordle_project/wordle_game_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WordleGame _game;

  @override
  void initState() {
    super.initState();
    _game = WordleGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wordle",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Wordle"),
        ),
        body: WordleGameWidget(game: _game),
      ),
    );
  }
}
