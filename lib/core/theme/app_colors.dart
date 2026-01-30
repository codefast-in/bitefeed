import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrange = Color(0xFFFFA10A);
  static const Color primaryRed = Color(0xFFDA2744);
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    // colors: [primaryOrange, primaryRed],
    colors: [
      Color(0xFFEF6727),
      Color(0xFFEC5F29),
      Color(0xFFE9562E),
      Color(0xFFE44735),
      Color(0xFFDA2744),
    ],
  );
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x33FFA10A), // primaryOrange with 60% opacity
      Color(0x33DA2744), // primaryRed with 60% opacity
    ],
  );
  static const LinearGradient verticalGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryOrange, primaryRed],
  );

  static const Color textGrey = Color(0xFF8C8C8C);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
