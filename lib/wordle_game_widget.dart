import 'package:flutter/material.dart';
import 'package:wordle_project/wordle_game.dart';

class WordleGameWidget extends StatefulWidget {
  final WordleGame game;

  const WordleGameWidget({super.key, required this.game});

  @override
  State<WordleGameWidget> createState() => _WordleGameWidgetState();
}

class _WordleGameWidgetState extends State<WordleGameWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.game.gameOver)
          _buildGameOverWidget()
        else
          _buildGamePlayWidget(),
      ],
    );
  }

  Widget _buildGameOverWidget() {
    return Column(
      children: [
        if (widget.game.attempts >= 6) ...[
          Text(
            "게임 오버",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("정답은 "),
              Text(
                "\"${widget.game.currentWord}\"",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ] else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "정답입니다!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () => setState(() => widget.game.startNewGame()),
          child: const Text("다시 플레이"),
        ),
      ],
    );
  }

  Widget _buildGamePlayWidget() {
    return Column(
      children: [
        for (int i = 0; i < widget.game.attempts; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 5; j++) _buildLetterContainer(i, j),
            ],
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(30),
          child: TextField(
            onSubmitted: _handleGuessSubmission,
            decoration: const InputDecoration(hintText: "5글자 단어를 입력하세요"),
          ),
        )
      ],
    );
  }

  Widget _buildLetterContainer(int i, int j) {
    final letter = widget.game.guesses[i][j];
    final currentWord = widget.game.currentWord;

    Color getColor() {
      if (letter == currentWord[j]) return Colors.green;
      if (currentWord.contains(letter)) return Colors.yellow;
      return Colors.grey;
    }

    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleGuessSubmission(String value) {
    if (value.length == 5) {
      if (widget.game.makeGuess(value)) {
        setState(() {});
      } else {
        _showTopBanner("단어 목록에 없습니다");
      }
    } else {
      _showTopBanner("5글자 단어를 입력해주세요");
    }
  }

  void _showTopBanner(String message) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        leading: const Icon(Icons.info),
        backgroundColor: Colors.lightBlue,
        actions: [
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );

    // 3초 후 자동으로 배너 숨기기
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        }
      },
    );
  }
}
