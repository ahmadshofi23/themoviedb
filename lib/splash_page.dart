import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var widht = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset('assets/logo.png', width: widht * 0.3),
            Text(
              'TMDB',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
            ),
            Spacer(),

            Image.asset('assets/tiketux.png', width: widht * 0.2),
          ],
        ),
      ),
    );
  }
}
