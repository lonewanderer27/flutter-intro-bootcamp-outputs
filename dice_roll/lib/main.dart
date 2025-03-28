import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:dice_roll/widgets/dice.dart';
import 'package:dice_roll/widgets/dice_rolling.dart';
import 'package:flutter/material.dart';
import 'package:dice_roll/constants/assets.dart';

void main() {
  runApp(DiceApp());
}

class DiceApp extends StatefulWidget {
  const DiceApp({super.key});

  @override
  State<DiceApp> createState() => _DiceAppState();
}

class _DiceAppState extends State<DiceApp> {
  late AudioPlayer _player;
  int _currentDice = 0;
  bool _rolling = false;

  Future<void> _playSound() async {
    await _player.play(AssetSource(Assets.diceRollSound), volume: 100.00);
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _roll() {
    setState(() {
      // roll state to true
      _rolling = true;

      // play sound
      _playSound();

      // initialize in advance what would be the next face
      _currentDice = Random().nextInt(5);

      // countdown to 5
      Timer(const Duration(milliseconds: 2500), () {
        setState(() {
          // set rolling to false
          _rolling = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.00),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _rolling == true
                    ? DiceRolling()
                    : Padding(
                        padding: const EdgeInsets.only(top: 60, bottom: 60),
                        child: Dice(no: _currentDice)),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      onPressed: _rolling == false ? _roll : null,
                      child: Text(_rolling == false ? 'Roll' : 'Rolling')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
