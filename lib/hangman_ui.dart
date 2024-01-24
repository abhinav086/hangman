// hangman_ui.dart

import 'package:flutter/material.dart';

class HangmanUI extends StatefulWidget {
  @override
  _HangmanUIState createState() => _HangmanUIState();
}

class _HangmanUIState extends State<HangmanUI> {
  String secretWord = "flutter"; // Change this to your desired word
  String displayedWord = "";
  List<String> guessedLetters = [];
  int attemptsLeft = 6;

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
        } else {
          attemptsLeft--;
        }
      });
    }

    if (attemptsLeft == 0) {
      // If attempts run out, reveal the correct word
      setState(() {
        displayedWord = secretWord;
      });
    }
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
          ],
        ),
      ),
    );
  }
}
