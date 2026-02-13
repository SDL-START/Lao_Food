import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Gradient Palette (Modern Coral/Pink) ──
  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryLight = Color(0xFFFF8E8E);
  static const Color primaryDark = Color(0xFFE85555);
  static const Color onPrimary = Colors.white;
  
  // ── Secondary Accent (Teal/Green) ──
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryLight = Color(0xFF6FE3DB);
  static const Color secondaryDark = Color(0xFF3DBDB5);
  
  // ── Tertiary Accent (Purple) ──
  static const Color tertiary = Color(0xFF9B59B6);
  static const Color tertiaryLight = Color(0xFFB07CC9);
  
  // ── Gradient Colors ──
  static const List<Color> primaryGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFF8E53),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF4ECDC4),
    Color(0xFF44A08D),
  ];
  
  static const List<Color> darkGradient = [
    Color(0xFF2C3E50),
    Color(0xFF34495E),
  ];
  
  static const List<Color> sunsetGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFF8E53),
    Color(0xFFFFD93D),
  ];

  // ── Background Colors ──
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color scaffoldBg = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  
  // ── Glassmorphism Colors ──
  static const Color glassWhite = Color(0x80FFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const Color glassPrimary = Color(0x1AFF6B6B);
  
  // ── Text Colors ──
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Colors.white;
  static const Color textMuted = Color(0xFFCBD5E1);
  
  // ── Status Colors (Modern) ──
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // ── Order Status Colors ──
  static const Color orderPlaced = Color(0xFF3B82F6);
  static const Color orderAccepted = Color(0xFF10B981);
  static const Color orderPreparing = Color(0xFFF59E0B);
  static const Color orderReady = Color(0xFF06B6D4);
  static const Color orderPickedUp = Color(0xFF8B5CF6);
  static const Color orderOnTheWay = Color(0xFFEC4899);
  static const Color orderDelivered = Color(0xFF10B981);
  static const Color orderCancelled = Color(0xFFEF4444);
  
  // ── UI Elements ──
  static const Color divider = Color(0xFFE2E8F0);
  static const Color shadow = Color(0x0D000000);
  static const Color shadowStrong = Color(0x1A000000);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF1F5F9);
  
  // ── Ratings & Reviews ──
  static const Color starActive = Color(0xFFFFB800);
  static const Color starInactive = Color(0xFFE2E8F0);
  
  // ── Online/Offline ──
  static const Color online = Color(0xFF10B981);
  static const Color offline = Color(0xFF94A3B8);
  static const Color badge = Color(0xFFFF6B6B);
  
  // ── Category Colors ──
  static const Color categoryFood = Color(0xFFFF6B6B);
  static const Color categoryDrink = Color(0xFF4ECDC4);
  static const Color categoryDessert = Color(0xFFFFB6C1);
  static const Color categorySnack = Color(0xFFFFD93D);
  static const Color categoryHealthy = Color(0xFF10B981);
  static const Color categoryFastFood = Color(0xFFF59E0B);
}
