import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = '';
  GameState gameState = GameState.readyToStart;
  Timer waitingTimer;
  Timer stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0xFF, 0x28, 0x2E, 0x3D),
      body: Stack(
        children: [
          Align(
            alignment: FractionalOffset(0.5, 0.1),
            child: Text('Test your\nreaction speed',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold)),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: Color.fromARGB(0xFF, 0x6D, 0x6D, 0x6D),
              child: SizedBox(
                width: 300,
                height: 160,
                child: Center(
                  child: Text(millisecondsText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.9),
            child: SizedBox(
              width: 200,
              height: 200,
              child: GestureDetector(
                onTap: () => setState(() {
                  switch (gameState) {
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      millisecondsText = '';
                      _startWaitingTimer();
                      break;
                    case GameState.waiting:
                      break;
                    case GameState.canBeStopped:
                      gameState = GameState.readyToStart;
                      stoppableTimer?.cancel();
                      break;
                  }
                }),
                child: ColoredBox(
                  color: Color(_getButtonColor()),
                  child: Center(
                    child: Text(_getButtonText(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return 0xFF40CA88;
      case GameState.waiting:
        return 0xFFE0982D;
      case GameState.canBeStopped:
        return 0xFFE02D47;
    }
  }


  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return 'START';
      case GameState.waiting:
        return 'WAIT';
      case GameState.canBeStopped:
        return 'STOP';
    }
  }

  void _startWaitingTimer() {
    final randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = '${timer.tick * 16} ms';
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
