import 'package:flutter/material.dart';

class LumiAgeButtonStyles {
  static const double height = 45;
  static const double radius = 14;

  static const Color bg = Color(0xFFF7F9FC);
  static const Color selectedBg = Color(0xFFE4F4F8);
  static const Color border = Color(0xFFD7DEE7);
  static const Color selectedBorder = Color(0xFF7ECFE2);
  static const Color text = Color(0xFF1E2A33);

  static ButtonStyle unselected = OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(height),
    backgroundColor: bg,
    side: const BorderSide(color: border, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    foregroundColor: text,
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  );

  static ButtonStyle selected = ElevatedButton.styleFrom(
    elevation: 0,
    minimumSize: const Size.fromHeight(height),
    backgroundColor: selectedBg,
    foregroundColor: text,
    side: const BorderSide(color: selectedBorder, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  );
}
