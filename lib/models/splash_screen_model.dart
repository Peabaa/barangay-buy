import 'package:flutter/material.dart';

class SplashScreenModel {
  final Widget nextScreen;
  final Duration splashDuration;
  final Duration transitionDuration;
  bool isNavigating;

  SplashScreenModel({
    required this.nextScreen,
    this.splashDuration = const Duration(seconds: 3),
    this.transitionDuration = const Duration(milliseconds: 800),
    this.isNavigating = false,
  });

  SplashScreenModel copyWith({
    Widget? nextScreen,
    Duration? splashDuration,
    Duration? transitionDuration,
    bool? isNavigating,
  }) {
    return SplashScreenModel(
      nextScreen: nextScreen ?? this.nextScreen,
      splashDuration: splashDuration ?? this.splashDuration,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      isNavigating: isNavigating ?? this.isNavigating,
    );
  }
}
