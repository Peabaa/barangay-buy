import 'package:flutter/material.dart';
import 'dart:async';
import '../models/splash_screen_model.dart';

class SplashScreenController {
  
  // Set navigation state
  static SplashScreenModel setNavigationState(
    SplashScreenModel currentModel,
    bool isNavigating,
  ) {
    return currentModel.copyWith(isNavigating: isNavigating);
  }

  // Handle splash screen timer and navigation
  static void startSplashTimer({
    required BuildContext context,
    required SplashScreenModel model,
    required Function(SplashScreenModel) onModelUpdate,
  }) {
    Timer(model.splashDuration, () {
      if (context.mounted) {
        onModelUpdate(setNavigationState(model, true));
        navigateToNextScreen(context, model);
      }
    });
  }

  // Navigate to the next screen with fade transition
  static void navigateToNextScreen(BuildContext context, SplashScreenModel model) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => model.nextScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: model.transitionDuration,
      ),
    );
  }

  // Get logo image widget with proper styling
  static Widget getLogoImage(double height) {
    return Image.asset(
      'assets/images/Logo.png',
      height: height,
    );
  }

  // Get background image widget
  static Widget getBackgroundImage() {
    return Image.asset(
      'assets/images/background.png',
      fit: BoxFit.cover,
    );
  }

  // Get title text with stroke effect
  static Widget getTitleText({
    required String title,
    required double fontSize,
    required double relWidth,
    required double relHeight,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'SofiaSansCondensed',
            fontSize: fontSize,
            foreground: (Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.white),
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(relWidth, relHeight),
                blurRadius: relWidth * 4,
              ),
            ],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'SofiaSansCondensed',
            fontSize: fontSize,
            color: const Color(0xFFA22304),
          ),
        ),
      ],
    );
  }

  // Get main container styling
  static EdgeInsets getContainerMargin(double horizontalMargin) {
    return EdgeInsets.symmetric(horizontal: horizontalMargin);
  }

  static EdgeInsets getContainerPadding(double padding) {
    return EdgeInsets.all(padding);
  }

  // Get responsive dimensions helpers
  static double getRelativeWidth(double screenWidth, double dp) {
    return screenWidth * (dp / 412);
  }

  static double getRelativeHeight(double screenHeight, double dp) {
    return screenHeight * (dp / 915);
  }

  // Get scaffold configuration
  static Widget buildSplashScaffold({
    required Widget backgroundImage,
    required Widget content,
  }) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          backgroundImage,
          Center(
            child: SingleChildScrollView(
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
