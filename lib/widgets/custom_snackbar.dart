import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomSnackBar {
  /// Shows a custom black floating snackbar with the specified message
  /// 
  /// [message] - The main message to display (left side, white text)
  /// [context] - BuildContext to show the snackbar
  /// [duration] - How long to show the snackbar (default: 3 seconds)
  /// [actionLabel] - Text for the dismiss action (default: "Dismiss")
  /// [onDismiss] - Callback when dismiss is tapped
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    // String actionLabel = 'Dismiss',
    // VoidCallback? onDismiss,
  }) {
    final size = MediaQuery.of(context).size;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.015,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Main message (left side, white text)
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: size.width * 0.042,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Dismiss button (right side, light gray text)
              // GestureDetector(
              //   onTap: () {
              //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //     onDismiss?.call();
              //   },
              //   child: Text(
              //     actionLabel,
              //     style: TextStyle(
              //       color: AppColors.textSecondary,
              //       fontSize: size.width * 0.038,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        backgroundColor: Colors.black, // Black background
        behavior: SnackBarBehavior.floating, // Floating behavior for margins
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.02,
        ),
        elevation: 0,
      ),
    );
  }

  /// Shows a success snackbar (same black design)
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    // String actionLabel = 'Dismiss',
    // VoidCallback? onDismiss,
  }) {
    show(context, message: message, duration: duration,
        // actionLabel: actionLabel, onDismiss: onDismiss
    );
  }

  /// Shows an error snackbar (same black design)
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    // String actionLabel = 'Dismiss',
    // VoidCallback? onDismiss,
  }) {
    show(context, message: message, duration: duration,
        // actionLabel: actionLabel, onDismiss: onDismiss
    );
  }

  /// Shows an info snackbar (same black design)
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    // String actionLabel = 'Dismiss',
    // VoidCallback? onDismiss,
  }) {
    show(context, message: message, duration: duration,
        // actionLabel: actionLabel, onDismiss: onDismiss
    );
  }
}

