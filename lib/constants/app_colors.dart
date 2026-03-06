import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme Colors (Modern Dark + Neon Accent)
  // Primary: Midnight Black
  static const Color primary = Color(0xFF0F0F14);
  static const Color primaryDark = Color(0xFF0A0A0E);
  static const Color primaryLight = Color(0xFF1A1A24);
  
  // Secondary: Deep Charcoal
  static const Color secondary = Color(0xFF1C1C24);
  static const Color secondaryDark = Color(0xFF15151C);
  static const Color secondaryLight = Color(0xFF252530);
  
  // Accent: Neon Purple
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentDark = Color(0xFF7C3AED);
  static const Color accentLight = Color(0xFFA78BFA);

  // Alternate Accent: Electric Blue
  static const Color electricBlue = Color(0xFF38BDF8);

  // Success / Live: Neon Green
  static const Color success = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF16A34A);
  static const Color successLight = Color(0xFF4ADE80);
  
  // Background Colors (Dark Theme)
  static const Color background = Color(0xFF0F0F14);
  static const Color surface = Color(0xFF1C1C24);
  static const Color surfaceDark = Color(0xFF15151C);
  static const Color surfaceLight = Color(0xFF252530);
  
  // Text Colors (Dark Theme)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  static const Color textLight = Color(0xFF71717A);
  static const Color textLightDark = Color(0xFF71717A);
  
  // Accent Colors
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED),
      Color(0xFF6366F1),
      Color(0xFF3B82F6),],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ButtonGradient = LinearGradient(
    colors: [Color(0xFF1A1A23),
      Color(0xFF0F0F14),],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), // accentDark
      Color(0xFF9333EA),
      Color(0xFFA855F7),],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // For backward compatibility (keeping old names)
  static const Color primaryOld = accent;
}

