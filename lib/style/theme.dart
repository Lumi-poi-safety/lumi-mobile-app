import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildLumiTheme() {
  const primary = Color(0xFF4AB7C4); // soft cyan/teal
  const text = Color(0xFF1B1B1B);

  const inputBg = Color(0xFFF7F9FC); // very light fill
  const inputBorder = Color(0xFFD7DEE7); // soft gray border
  const inputFocused = Color(0xFF7ECFE2); // cyan focus
  const inputText = Color(0xFF1E2A33); // dark text
  const inputHint = Color(0xFF9AA8B5); // muted hint
  const selectedBg = Color(0xFFE4F4F8);
  // const selectedBorder = Color(0xFF7ECFE2);

  OutlineInputBorder outline(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Color(0XFFFEFEFE),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0XFFFEFEFE),
      elevation: 0,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        bodyLarge: TextStyle(color: text, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: text, fontSize: 14, height: 1.4),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: inputBg,

      // the “Your name” field looks compact + centered vertically
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      // remove Material default underline/extra clutter
      border: outline(inputBorder),
      enabledBorder: outline(inputBorder),
      disabledBorder: outline(inputBorder.withOpacity(0.6)),
      errorBorder: outline(const Color(0xFFE06B6B)),
      focusedErrorBorder: outline(const Color(0xFFE06B6B), width: 1.2),

      // soft cyan focus ring (slightly thicker)
      focusedBorder: outline(inputFocused, width: 1.4),

      // typography
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: inputHint,
      ),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: inputHint,
      ),
      floatingLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: inputFocused,
      ),
      helperStyle: TextStyle(
        fontSize: 12,
        color: inputText.withOpacity(0.55),
        height: 1.2,
      ),
      errorStyle: const TextStyle(fontSize: 12, height: 1.2),

      // small details
      hintFadeDuration: const Duration(milliseconds: 120),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: inputBg,
      selectedColor: selectedBg,
      disabledColor: inputBg,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: inputBorder, width: 1),
      ),

      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: text,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: text,
      ),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      labelPadding: EdgeInsets.zero,

      elevation: 0,
      pressElevation: 0,
    ),
  );
}
