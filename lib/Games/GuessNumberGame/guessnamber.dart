import 'package:flutter/material.dart';
import 'dart:math';


class GameScreenGuess extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreenGuess> {
  late int targetNumber;
  late int guess;
  late String message;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    Random random = Random();
    targetNumber = random.nextInt(100) + 1;
    guess = 0;
    message = 'Guess a number between 1 and 100';
    gameOver = false;
  }

  void checkGuess() {
    if (guess == null) {
      return;
    }

    if (guess == targetNumber) {
      setState(() {
        message = 'Congratulations! You guessed the number!';
        gameOver = true;
      });
    } else if (guess < targetNumber) {
      setState(() {
        message = 'Try a higher number';
      });
    } else {
      setState(() {
        message = 'Try a lower number';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guess the Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                message,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (!gameOver)
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      guess = int.tryParse(value)!;
                    });
                  },
                  onSubmitted: (value) {
                    checkGuess();
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your guess',
                  ),
                ),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: checkGuess,
                child: Text('Check'),
              ),
              SizedBox(height: 20),
              if (gameOver)
                FloatingActionButton(
                  onPressed: startNewGame,
                  child: Text('Play Again'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
