import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/select_barangay_model.dart';
import '../views/user/home.dart';

class SelectBarangayController {
  
  // Update selected barangay
  static SelectBarangayModel updateSelectedBarangay(
    SelectBarangayModel currentModel,
    String? newBarangay,
  ) {
    return currentModel.copyWith(selectedBarangay: newBarangay);
  }

  // Set loading state
  static SelectBarangayModel setLoadingState(
    SelectBarangayModel currentModel,
    bool isLoading,
  ) {
    return currentModel.copyWith(isLoading: isLoading);
  }

  // Handle back navigation
  static void handleBackNavigation(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Handle barangay confirmation
  static Future<void> confirmBarangay({
    required BuildContext context,
    required SelectBarangayModel model,
    required Function(SelectBarangayModel) onModelUpdate,
  }) async {
    if (!model.canConfirm) return;

    // Set loading state
    onModelUpdate(setLoadingState(model, true));

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && model.selectedBarangay != null) {
        // Save barangay to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'barangay': model.selectedBarangay});

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Barangay saved!')),
          );

          // Navigate to HomePage
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save barangay.')),
        );
      }
    } finally {
      // Reset loading state
      onModelUpdate(setLoadingState(model, false));
    }
  }

  // Get dropdown button styling
  static InputDecoration getDropdownDecoration() {
    return const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.zero,
    );
  }

  // Get confirm button style
  static ButtonStyle getConfirmButtonStyle({
    required double borderRadius,
    required bool isEnabled,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: isEnabled ? const Color(0xFFA22304) : Colors.grey,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.zero,
    );
  }

  // Get text styles for different components
  static TextStyle getWelcomeTextStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'RobotoCondensed',
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.72,
      height: 1.17182,
      shadows: const [
        Shadow(offset: Offset(1, 0), color: Color(0xFFA22304)),
        Shadow(offset: Offset(-1, 0), color: Color(0xFFA22304)),
        Shadow(offset: Offset(0, 1), color: Color(0xFFA22304)),
        Shadow(offset: Offset(0, -1), color: Color(0xFFA22304)),
      ],
    );
  }

  static TextStyle getSubtitleTextStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: const Color(0xFFA22304),
      letterSpacing: 0.32,
      height: 1.17182,
    );
  }

  static TextStyle getDropdownTextStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF611A04),
      letterSpacing: 0.32,
      height: 1.17182,
    );
  }

  static TextStyle getConfirmButtonTextStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.4,
      height: 1.17182,
    );
  }

  // Get container decoration for the main form
  static BoxDecoration getMainContainerDecoration(double borderRadius, double shadowBlurRadius, double shadowOffsetX, double shadowOffsetY) {
    return BoxDecoration(
      color: const Color(0xFFFF5B29).withOpacity(0.57),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(shadowOffsetX, shadowOffsetY),
          blurRadius: shadowBlurRadius,
        ),
      ],
    );
  }

  // Get dropdown container decoration
  static BoxDecoration getDropdownContainerDecoration(double borderRadius) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: const Color(0xFF611A04),
        width: 1,
      ),
    );
  }
}
