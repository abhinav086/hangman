// hangman_ui.dart

import 'package:flutter/material.dart';

class HangmanUI extends StatefulWidget {
  @override
  _HangmanUIState createState() => _HangmanUIState();
}

class _HangmanUIState extends State<HangmanUI> {
  String secretWord = "flutter"; // Initial word, change this to your desired word
  String displayedWord = "";
  List<String> guessedLetters = [];
  int attemptsLeft = 6;
  bool isHangmanFlying = false;

  @override
  void initState() {
    super.initState();
    initializeDisplayedWord();
  }

  void initializeDisplayedWord() {
    displayedWord = secretWord.replaceAll(RegExp(r'[a-z]'), '_');
  }

  void makeGuess(String letter) {
    if (attemptsLeft > 0 && !guessedLetters.contains(letter)) {
      setState(() {
        guessedLetters.add(letter);

        if (secretWord.contains(letter)) {
          for (int i = 0; i < secretWord.length; i++) {
            if (secretWord[i] == letter) {
              displayedWord = displayedWord.substring(0, i) +
                  letter +
                  displayedWord.substring(i + 1);
            }
          }
          isHangmanFlying = true; // Hangman is flying on correct guess
        } else {
          attemptsLeft--;
          isHangmanFlying = false; // Hangman crashes on wrong guess
        }
      });
    }

    if (attemptsLeft == 0 || displayedWord == secretWord) {
      // If attempts run out or correct word is guessed
      setState(() {
        displayedWord = secretWord;
      });

      // Display dialog based on game result
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(attemptsLeft == 0 ? 'You Lose!' : 'You Win!'),
            content: Text(
              attemptsLeft == 0
                  ? 'Sorry! You ran out of attempts. Better luck next time!'
                  : 'Congratulations! You guessed the word.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetQuiz();
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    }
  }

  void resetQuiz() {
    setState(() {
      secretWord = _getNewWord(); // Change this to your desired method for getting a new word
      displayedWord = "";
      guessedLetters = [];
      attemptsLeft = 6;
      isHangmanFlying = false; // Reset hangman status
      initializeDisplayedWord();
    });
  }

  String _getNewWord() {
    // Replace this with your logic to get a new word
    // For simplicity, a list of words is used here.
    List<String> wordList = ["flutter", "dart", "widget", "mobile", "app"];
    return wordList[DateTime.now().millisecondsSinceEpoch % wordList.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayedWord,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hint: ${secretWord.isNotEmpty ? '${secretWord[0]}...${secretWord[secretWord.length - 1]}' : ''}',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hangman:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Text(
                  isHangmanFlying ? '👍' : '👎',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Guessed Letters: ${guessedLetters.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Attempts Left: $attemptsLeft',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 5.0,
              runSpacing: 5.0,
              children: List.generate(
                26,
                    (index) {
                  String letter = String.fromCharCode('a'.codeUnitAt(0) + index);
                  return ElevatedButton(
                    onPressed: () {
                      makeGuess(letter);
                    },
                    child: Text(letter),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetQuiz();
              },
              child: Text('Reset Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
