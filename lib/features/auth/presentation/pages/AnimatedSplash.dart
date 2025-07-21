import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class AnimatedSplash extends StatelessWidget {
  const AnimatedSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/loading.json',
          width: 200,
          height: 200,
          repeat: true,
        ),
      ),
    );
  }
}
