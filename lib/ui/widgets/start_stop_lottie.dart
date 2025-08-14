import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartStopLottie extends StatelessWidget {
  const StartStopLottie({super.key, required this.isRunning});

  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    final String asset = isRunning ? 'assets/lottie/started.json' : 'assets/lottie/stopped.json';
    return Lottie.asset(asset, height: 140, repeat: true);
  }
}


