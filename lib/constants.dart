//file constants.dart digunakan untuk menyimpan konstanta warna dan style aplikasi

import 'package:flutter/material.dart';

// Warna utama aplikasi
const Color kPrimaryColor = Color(0xFF6366F1); // Purple
const Color kSecondaryColor = Color(0xFF8B5CF6); // Lighter Purple
const Color kBackgroundColor = Color(0xFFF8F9FE); // Very Light Cool Gray
const Color kSurfaceColor = Color(0xFFFFFFFF); // White for cards
const Color kTextColor = Color(0xFF1E1E1E); // Dark text
const Color kTextSecondaryColor = Color(0xFF6B7280); // Gray text

// Shadow Style
final BoxShadow kCardShadow = BoxShadow(
  color: const Color(0xFF6366F1).withOpacity(0.08),
  blurRadius: 24,
  offset: const Offset(0, 8),
);

// Warna aksen
const Color kAccentGold = Color(0xFFD4AF37); // Gold accent
const Color kAccentOrange = Color(0xFFFFA07A);
const Color kAccentPink = Color(0xFFEC77AB);
const Color kAccentGreen = Color(0xFF43E97B);
const Color kAccentPurple = Color(0xFF667EEA);
const Color kAccentBlue = Color(0xFF4FACFE);

// Warna status
const Color kSuccessColor = Color(0xFF10B981);
const Color kWarningColor = Color(0xFFF59E0B);
const Color kErrorColor = Color(0xFFEF4444);
const Color kInfoColor = Color(0xFF3B82F6);

// Gradients
const List<Color> kPrimaryGradient = [Color(0xFF6366F1), Color(0xFF8B5CF6)];

// Days
const List<String> kDays = [
  "Senin",
  "Selasa",
  "Rabu",
  "Kamis",
  "Jumat",
  "Sabtu",
];

// Helper function for random colors
Color pickRandomColor() {
  final colors = [kAccentBlue, kAccentOrange, kAccentPink, kAccentGreen];
  return (colors..shuffle()).first;
}
