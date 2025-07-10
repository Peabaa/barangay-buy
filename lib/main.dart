import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/splash_screen.dart';
import 'views/login_signup.dart';


// Pixel 7 reference: 412x915 dp (logical pixels)


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // If using generated firebase_options.dart, use:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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