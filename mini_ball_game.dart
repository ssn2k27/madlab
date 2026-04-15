import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double paddleX = 0.5; // center (0 to 1)
  double ballX = 0.5;
  double ballY = 0;
  double speed = 0.01;

  int score = 0;

  Timer? timer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        ballY += speed;

        /// BALL REACHED BOTTOM
        if (ballY >= 0.9) {
          double paddleLeft = paddleX - 0.15;
          double paddleRight = paddleX + 0.15;

          /// CHECK CATCH
          if (ballX >= paddleLeft && ballX <= paddleRight) {
            score++;
          } else {
            score--;
          }

          /// RESET BALL
          ballY = 0;
          ballX = random.nextDouble();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updatePaddle(double dx, double width) {
    setState(() {
      paddleX = dx / width;
      paddleX = paddleX.clamp(0.15, 0.85);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Catch The Ball")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return Column(
            children: [
              /// SCORE
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Score: $score",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              /// GAME AREA
              Expanded(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    updatePaddle(details.localPosition.dx, width);
                  },
                  child: Stack(
                    children: [
                      /// BALL
                      Positioned(
                        left: ballX * width - 10,
                        top: ballY * height,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      /// PADDLE
                      Positioned(
                        bottom: 20,
                        left: paddleX * width - 60,
                        child: Container(
                          width: 120,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// SPEED CONTROL
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("Speed"),
                    Slider(
                      value: speed,
                      min: 0.005,
                      max: 0.03,
                      onChanged: (value) {
                        setState(() {
                          speed = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}