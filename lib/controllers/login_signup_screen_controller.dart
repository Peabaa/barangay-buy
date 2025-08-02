import 'package:flutter/material.dart';
import '../models/login_signup_screen_model.dart';
import '../views/login_signup_forms.dart';

class LoginSignupScreenController {
  // Static methods for handling login/signup screen operations

  /// Navigate to signup screen with fade transition
  static Future<void> navigateToSignup(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            const LoginScreen(isLogin: false),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  /// Navigate to login screen with fade transition
  static Future<void> navigateToLogin(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  /// Update model with button selection state
  static LoginSignupScreenModel updateButtonSelection({
    required LoginSignupScreenModel currentModel,
    bool? isSignupSelected,
    bool? isLoginSelected,
  }) {
    return currentModel.copyWith(
      isSignupSelected: isSignupSelected,
      isLoginSelected: isLoginSelected,
    );
  }

  /// Set loading state
  static LoginSignupScreenModel setLoading(
    LoginSignupScreenModel currentModel,
    bool isLoading,
  ) {
    return currentModel.copyWith(isLoading: isLoading);
  }

  /// Set error message
  static LoginSignupScreenModel setError(
    LoginSignupScreenModel currentModel,
    String? errorMessage,
  ) {
    return currentModel.copyWith(errorMessage: errorMessage);
  }

  /// Clear all states
  static LoginSignupScreenModel clearStates(LoginSignupScreenModel currentModel) {
    return currentModel.copyWith(
      isSignupSelected: false,
      isLoginSelected: false,
      errorMessage: null,
      isLoading: false,
    );
  }

  /// Get signup button style
  static ButtonStyle getSignupButtonStyle({
    required Size minimumSize,
    required double borderRadius,
    required double borderWidth,
    required double fontSize,
    bool isSelected = false,
  }) {
    return ElevatedButton.styleFrom(
      minimumSize: minimumSize,
      backgroundColor: isSelected ? const Color(0xFFFF5B29) : Colors.white,
      foregroundColor: isSelected ? Colors.white : const Color(0xFFFF5B29),
      textStyle: TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: fontSize,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: const Color(0xFFFF5B29),
          width: borderWidth,
        ),
      ),
    );
  }

  /// Get login button style
  static ButtonStyle getLoginButtonStyle({
    required Size minimumSize,
    required double borderRadius,
    required double borderWidth,
    required double fontSize,
    bool isSelected = false,
  }) {
    return ElevatedButton.styleFrom(
      minimumSize: minimumSize,
      backgroundColor: isSelected ? Colors.white : const Color(0xFFFF5B29),
      foregroundColor: isSelected ? const Color(0xFFFF5B29) : Colors.white,
      textStyle: TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: fontSize,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: const Color(0xFFFF5B29),
          width: borderWidth,
        ),
      ),
    );
  }

  /// Get title text style for the main app title
  static TextStyle getTitleTextStyle({
    required double fontSize,
    required Color color,
    bool isOutline = false,
  }) {
    if (isOutline) {
      return TextStyle(
        fontFamily: 'SofiaSansCondensed',
        fontSize: fontSize,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white,
        shadows: const [
          Shadow(
            color: Colors.black26,
            offset: Offset(3, 5),
            blurRadius: 12,
          ),
        ],
      );
    } else {
      return TextStyle(
        fontFamily: 'SofiaSansCondensed',
        fontSize: fontSize,
        color: color,
      );
    }
  }

  /// Calculate responsive dimensions
  static double calculateRelativeWidth(double dp, double screenWidth) {
    return screenWidth * (dp / 412);
  }

  static double calculateRelativeHeight(double dp, double screenHeight) {
    return screenHeight * (dp / 915);
  }

  /// Get divider properties
  static Widget getDivider({
    required Color color,
    required double thickness,
  }) {
    return Divider(
      color: color,
      thickness: thickness,
    );
  }

  /// Handle button press with feedback
  static Future<void> handleButtonPress({
    required BuildContext context,
    required VoidCallback onPressed,
    LoginSignupScreenModel? model,
  }) async {
    if (model?.isLoading == true) return; // Prevent multiple presses
    
    try {
      onPressed();
    } catch (e) {
      // Handle any navigation errors
      debugPrint('Navigation error: $e');
    }
  }

  /// Validate screen state
  static bool isValidState(LoginSignupScreenModel model) {
    return !model.isLoading && model.errorMessage == null;
  }

  /// Get background decoration
  static Widget getBackgroundImage() {
    return Image.asset(
      'assets/images/background.png',
      fit: BoxFit.cover,
    );
  }

  /// Get logo widget
  static Widget getLogoWidget(double height) {
    return Image.asset(
      'assets/images/Logo.png',
      height: height,
    );
  }
}
