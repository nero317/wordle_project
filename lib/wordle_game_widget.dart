import 'package:flutter/material.dart';
import 'package:wordle_project/wordle_game.dart';

class WordleGameWidget extends StatefulWidget {
  final WordleGame game;

  const WordleGameWidget({super.key, required this.game});

  @override
  State<WordleGameWidget> createState() => _WordleGameWidgetState();
}

class _WordleGameWidgetState extends State<WordleGameWidget> {
  String _currentGuess = '';

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

  // 게임 오버 위젯
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
          onPressed: () => setState(() {
            widget.game.startNewGame();
            widget.game.correctLetters.clear();
            widget.game.presentLetters.clear();
            widget.game.absentLetters.clear();
          }),
          child: const Text("다시 플레이"),
        ),
      ],
    );
  }

  Widget _buildGamePlayWidget() {
    return Column(
      children: [
        for (int i = 0; i < 6; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 5; j++) _buildLetterContainer(i, j),
            ],
          ),
        const SizedBox(height: 50),
        _buildCurrentGuessDisplay(),
        const SizedBox(height: 50),
        _buildVirtualKeyboard(),
      ],
    );
  }

  Widget _buildVirtualKeyboard() {
    const keys = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '⌫'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M', 'ENTER'],
    ]; //키보드 배열

    return Column(
      children: keys.map((row) {
        // 각 키보드 행을 매핑하여 Row 위젯 생성
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            // 각 키를 매핑하여 버튼 생성
            return Padding(
              padding: const EdgeInsets.all(2),
              child: SizedBox(
                // ENTER와 ⌫ 키는 50의 너비로, 나머지 키는 35의 너비로 설정
                width: key == 'ENTER' || key == '⌫' ? 50 : 35,
                height: 35,
                child: ElevatedButton(
                  // 키 누름 이벤트 처리
                  onPressed: () => _handleKeyPress(key),
                  style: ElevatedButton.styleFrom(
                    // 키의 현재 상태에 따라 배경색 결정 (맞춘 글자, 위치가 틀린 글자, 없는 글자 등)
                    backgroundColor: _getKeyColor(key),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    key,
                    style: TextStyle(
                      // ENTER와 ⌫ 키는 10 크기의 폰트로, 나머지 키는 14 크기의 폰트로 설정
                      fontSize: key.length > 1 ? 10 : 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  // 현재 입력된 단어 표시
  Widget _buildCurrentGuessDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              index < _currentGuess.length ? _currentGuess[index] : '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _getKeyColor(String key) {
    if (widget.game.correctLetters.contains(key)) {
      return Colors.green;
    } else if (widget.game.presentLetters.contains(key)) {
      return Colors.yellow;
    } else if (widget.game.absentLetters.contains(key)) {
      return Colors.grey;
    }
    return Colors.blueGrey; // 기본 색상
  }

  void _handleKeyPress(String key) {
    setState(() {
      if (key == '⌫') {
        if (_currentGuess.isNotEmpty) {
          _currentGuess = _currentGuess.substring(0, _currentGuess.length - 1);
        }
      } else if (key == 'ENTER') {
        if (_currentGuess.length == 5) {
          handleGuessSubmission(_currentGuess);
          _currentGuess = '';
        }
      } else if (_currentGuess.length < 5) {
        _currentGuess += key;
      }
    });
  }

  // 입력된 단어 표시
  //TODO : 박스의 기본색깔 노란색되는 문제 해겨
  Widget _buildLetterContainer(int i, int j) {
    final letter = i < widget.game.attempts ? widget.game.guesses[i][j] : '';
    final currentWord = widget.game.currentWord;

    Color getColor() {
      if (letter == currentWord[j]) return Colors.green;
      if (currentWord.contains(letter) && letter != '') return Colors.yellow;
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

  void handleGuessSubmission(String value) {
    if (value.length == 5) {
      if (widget.game.makeGuess(value)) {
        setState(() {});
      } else {
        showTopBanner("단어 목록에 없습니다");
      }
    }
  }

  void showTopBanner(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '닫기',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
