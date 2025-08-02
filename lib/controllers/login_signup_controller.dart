import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/login_signup_model.dart';
import '../controllers/auth_controller.dart';
import '../views/select_barangay.dart';
import '../views/user/home.dart';
import '../views/admin/admin_announcements.dart';

class LoginSignupController {
  // Static methods for handling login/signup operations

  /// Update model with new form values
  static LoginSignupModel updateForm({
    required LoginSignupModel currentModel,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLogin,
    bool? isLoading,
    String? errorMessage,
  }) {
    final updatedModel = currentModel.copyWith(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isLogin: isLogin,
      isLoading: isLoading,
      errorMessage: errorMessage,
    );

    // Update form validation
    final isValid = _validateForm(updatedModel);
    return updatedModel.copyWith(isFormValid: isValid);
  }

  /// Toggle between login and signup mode
  static LoginSignupModel toggleMode(LoginSignupModel currentModel) {
    return currentModel.copyWith(
      isLogin: !currentModel.isLogin,
      errorMessage: null, // Clear any previous errors
    );
  }

  /// Clear all form fields
  static LoginSignupModel clearForm(LoginSignupModel currentModel) {
    return currentModel.copyWith(
      username: '',
      email: '',
      password: '',
      confirmPassword: '',
      errorMessage: null,
      isFormValid: false,
    );
  }

  /// Validate form based on current mode
  static bool _validateForm(LoginSignupModel model) {
    if (model.isLogin) {
      // Login validation
      return model.email.trim().isNotEmpty && model.password.trim().isNotEmpty;
    } else {
      // Signup validation
      return model.username.trim().isNotEmpty &&
          model.email.trim().isNotEmpty &&
          model.password.trim().isNotEmpty &&
          model.confirmPassword.trim().isNotEmpty &&
          model.password == model.confirmPassword;
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    return password.length >= 6; // Basic validation
  }

  /// Get validation error message
  static String? getValidationError(LoginSignupModel model) {
    if (model.isLogin) {
      if (model.email.trim().isEmpty) return 'Please enter email address';
      if (model.password.trim().isEmpty) return 'Please enter password';
      if (!isValidEmail(model.email)) return 'Please enter a valid email address';
    } else {
      if (model.username.trim().isEmpty) return 'Please enter username';
      if (model.email.trim().isEmpty) return 'Please enter email address';
      if (model.password.trim().isEmpty) return 'Please enter password';
      if (model.confirmPassword.trim().isEmpty) return 'Please confirm password';
      if (!isValidEmail(model.email)) return 'Please enter a valid email address';
      if (!isValidPassword(model.password)) return 'Password must be at least 6 characters';
      if (model.password != model.confirmPassword) return 'Passwords do not match';
    }
    return null;
  }

  /// Handle login operation
  static Future<LoginSignupModel> handleLogin({
    required LoginSignupModel model,
    required BuildContext context,
  }) async {
    // Validate form first
    final validationError = getValidationError(model);
    if (validationError != null) {
      _showSnackBar(context, validationError);
      return model.copyWith(errorMessage: validationError);
    }

    // Set loading state
    var updatedModel = model.copyWith(isLoading: true, errorMessage: null);

    try {
      final authController = AuthController();
      final result = await authController.login(
        email: model.email.trim(),
        password: model.password.trim(),
        context: context,
      );

      if (result != null) {
        final uid = result.user?.uid;
        if (uid != null) {
          final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
          final role = doc.data()?['role'];
          final barangay = doc.data()?['barangay'] ?? 'N/A';

          // Navigate based on role
          if (role == 'admin') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AdminAnnouncements(selectedBarangay: barangay),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          }

          return updatedModel.copyWith(isLoading: false);
        }
      }

      // If we reach here, login failed
      return updatedModel.copyWith(
        isLoading: false,
        errorMessage: 'Login failed. Please try again.',
      );
    } catch (e) {
      return updatedModel.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred: ${e.toString()}',
      );
    }
  }

  /// Handle signup operation
  static Future<LoginSignupModel> handleSignup({
    required LoginSignupModel model,
    required BuildContext context,
  }) async {
    // Validate form first
    final validationError = getValidationError(model);
    if (validationError != null) {
      _showSnackBar(context, validationError);
      return model.copyWith(errorMessage: validationError);
    }

    // Set loading state
    var updatedModel = model.copyWith(isLoading: true, errorMessage: null);

    try {
      final authController = AuthController();
      final result = await authController.signUp(
        email: model.email.trim(),
        password: model.password.trim(),
        fullName: model.username.trim(),
        phone: '', // No phone field in this form
        context: context,
      );

      if (result != null) {
        _showSnackBar(context, 'Sign up successful!');
        
        // Navigate to Select Barangay Screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SelectBarangay(),
          ),
        );

        return updatedModel.copyWith(isLoading: false);
      }

      // If we reach here, signup failed
      return updatedModel.copyWith(
        isLoading: false,
        errorMessage: 'Sign up failed. Please try again.',
      );
    } catch (e) {
      return updatedModel.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred: ${e.toString()}',
      );
    }
  }

  /// Show snackbar message
  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Get button style for login/signup buttons
  static ButtonStyle getPrimaryButtonStyle(double borderRadius) {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA22304),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// Get button style for cancel buttons
  static ButtonStyle getCancelButtonStyle(double borderRadius, double borderWidth) {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFFA22304),
      side: BorderSide(color: const Color(0xFFA22304), width: borderWidth),
      textStyle: const TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// Get text field decoration
  static InputDecoration getTextFieldDecoration({
    required String hintText,
    required double fontSize,
    required double borderRadius,
    required double borderWidth,
    required double focusedBorderWidth,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: fontSize,
        color: const Color(0xFFD0D0D0).withOpacity(0.8),
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: const Color(0xFFA22304),
          width: borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: const Color(0xFFA22304),
          width: focusedBorderWidth,
        ),
      ),
    );
  }

  /// Get text field style
  static TextStyle getTextFieldStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'RobotoCondensed',
      fontSize: fontSize,
      color: const Color(0xFFA22304),
      fontWeight: FontWeight.bold,
    );
  }
}
