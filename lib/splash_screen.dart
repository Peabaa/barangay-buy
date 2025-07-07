import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreen({required this.nextScreen, Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.nextScreen,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: 130,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text( // Text Border Color
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: 64,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.white, // Border color
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(3, 5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        Text( // Text Fill Color
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: 64,
                            color: Color(0xFFA22304),
                          )
                        ),
                      ],
                    ),
                  ]
                ),
              ),
            ),
          ),
        ]
        
        
      ),
    );
  }
}