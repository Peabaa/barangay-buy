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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

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
                margin: EdgeInsets.symmetric(horizontal: relWidth(32)),
                padding: EdgeInsets.all(relWidth(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: relHeight(130),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text( // Text Border Color
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: relWidth(64),
                            foreground: (Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.white), // Border color
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(relWidth(3), relHeight(5)),
                                blurRadius: relWidth(12),
                              ),
                            ],
                          ),
                        ),
                        Text( // Text Fill Color
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: relWidth(64),
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