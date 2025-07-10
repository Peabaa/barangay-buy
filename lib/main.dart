import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/login_signup.dart';


// Pixel 7 reference: 412x915 dp (logical pixels)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(
        nextScreen: LoginSignupScreen(),
      ),
    );
  }
}