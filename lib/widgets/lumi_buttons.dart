import 'package:flutter/material.dart';

class LumiButtons {
  // Tune these to your palette
  static const Color c1 = Color(0xFFBFEAF3); // top (lighter)
  static const Color c2 = Color(0xFF65BFD3); // bottom (deeper)
  static const Color outline = Color(0xFFD7DEE7); // soft border
  static const Color textDark = Color(0xFF1E2A33);

  static const double height = 52;
  static const double radius = 28;

  // Primary pill with gradient + soft shadow
  static ButtonStyle primary = ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size.fromHeight(height)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    ),
    elevation: WidgetStateProperty.all(0),
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    shadowColor: WidgetStateProperty.all(Colors.transparent),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return Colors.white.withOpacity(0.10);
      }
      return null;
    }),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    foregroundColor: WidgetStateProperty.all(Colors.white),
  );

  // Secondary pill (outline / soft surface) like the age chips
  static ButtonStyle secondaryChip = ButtonStyle(
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    side: WidgetStateProperty.all(const BorderSide(color: outline, width: 1)),
    backgroundColor: WidgetStateProperty.all(const Color(0xFFF7F9FC)),
    foregroundColor: WidgetStateProperty.all(textDark),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return Colors.black.withOpacity(0.04);
      }
      return null;
    }),
  );

  // "Skip" style
  static ButtonStyle skip = TextButton.styleFrom(
    foregroundColor: textDark.withOpacity(0.55),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  );
}

/// Use this widget for the primary gradient button background.
class LumiPrimaryButton extends StatelessWidget {
  const LumiPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(LumiButtons.radius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [LumiButtons.c1, LumiButtons.c2],
        ),
        boxShadow: [
          BoxShadow(
            color: LumiButtons.c2.withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.65),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: LumiButtons.primary,
        child: Text(label),
      ),
    );
  }
}
