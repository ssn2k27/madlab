import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int time = 30;

  double x = 100;
  double y = 100;
  double size = 60;

  bool gameOver = false;
  bool tapped = false;

  Timer? timer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    time = 30;
    gameOver = false;

    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time--;
        if (time <= 0) {
          gameOver = true;
          t.cancel();
        }
      });
    });

    moveCircle();
  }

  void moveCircle() {
    setState(() {
      x = random.nextDouble() * 300;
      y = random.nextDouble() * 500;
    });
  }

  void onTapCircle() {
    if (gameOver) return;

    setState(() {
      score++;
      tapped = true;
    });

    // 💥 tap animation reset
    Future.delayed(Duration(milliseconds: 150), () {
      setState(() {
        tapped = false;
      });
    });

    moveCircle();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: gameOver
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Game Over",
                style:
                TextStyle(fontSize: 30, color: Colors.white)),
            Text("Score: $score",
                style:
                TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startGame,
              child: Text("Restart"),
            )
          ],
        ),
      )
          : Stack(
        children: [
          // 📊 Score + Timer
          Positioned(
            top: 40,
            left: 20,
            child: Text("Score: $score",
                style:
                TextStyle(color: Colors.white, fontSize: 18)),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Text("Time: $time",
                style:
                TextStyle(color: Colors.white, fontSize: 18)),
          ),

          // 🎯 Circle Target
          Positioned(
            left: x,
            top: y,
            child: GestureDetector(
              onTap: onTapCircle,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: tapped ? size + 20 : size,
                height: tapped ? size + 20 : size,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}