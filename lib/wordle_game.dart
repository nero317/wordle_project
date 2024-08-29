import 'dart:math';

import 'package:wordle_project/word_list.dart';

class WordleGame {
  String _currentWord = "";
  final List<String> _guesses = [];
  int _attempts = 0;
  bool _gameOver = false;

  WordleGame() {
    startNewGame();
  }

  void startNewGame() {
    final random = Random();
    _currentWord = WordList.words[random.nextInt(WordList.words.length)];
    _guesses.clear();
    _attempts = 0;
    _gameOver = false;
  }

  bool makeGuess(String guess) {
    if (!WordList.words.contains(guess.toUpperCase())) {
      return false;
    }
    _guesses.add(guess.toUpperCase());
    _attempts++;
    if (guess.toUpperCase() == _currentWord) {
      _gameOver = true;
    } else if (_attempts >= 6) {
      _gameOver = true;
    }
    return true;
  }

  List<String> get guesses => _guesses;
  int get attempts => _attempts;
  bool get gameOver => _gameOver;
  String get currentWord => _currentWord;
}
