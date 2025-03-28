import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dice_roll/constants/assets.dart';

class DiceRolling extends StatefulWidget {
  const DiceRolling({super.key});

  @override
  State<DiceRolling> createState() => _DiceRollingState();
}

class _DiceRollingState extends State<DiceRolling>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.diceRollAnim,
        controller: _controller, onLoaded: (comp) {
      _controller
        ..duration = comp.duration
        ..repeat(
          min: 0,
          max: 0.4
        );
    });
  }
}
