import 'dart:math' as math;
import 'package:flutter/material.dart';

class LumiLoading extends StatefulWidget {
  const LumiLoading({super.key, this.size = 84, this.label = "Searching safe places…"});

  final double size;
  final String label;

  @override
  State<LumiLoading> createState() => _LumiLoadingState();
}

class _LumiLoadingState extends State<LumiLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9FC);
    const c1 = Color(0xFFBFEAF3);
    const c2 = Color(0xFF65BFD3);
    const text = Color(0xFF1E2A33);

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value; // 0..1
        final breathe = 1.0 + 0.06 * math.sin(t * 2 * math.pi);
        final glow = 0.14 + 0.10 * (0.5 + 0.5 * math.sin((t + 0.2) * 2 * math.pi));

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: breathe,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(widget.size * 0.30),
                  boxShadow: [
                    BoxShadow(
                      color: c2.withOpacity(glow),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // soft shimmer ring
                    CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: _ShimmerRingPainter(progress: t, c1: c1, c2: c2),
                    ),
                    Image.asset("lib/assets/images/Lumi_f.png", width: 45, height: 45),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShimmerRingPainter extends CustomPainter {
  _ShimmerRingPainter({required this.progress, required this.c1, required this.c2});

  final double progress;
  final Color c1;
  final Color c2;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);

    final rect = Rect.fromCircle(center: center, radius: r * 0.46);
    final start = -math.pi / 2 + progress * 2 * math.pi;
    const sweep = math.pi * 0.85;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.10
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: [
          c1.withOpacity(0.0),
          c1.withOpacity(0.65),
          c2.withOpacity(0.80),
          c2.withOpacity(0.0),
        ],
        stops: const [0.0, 0.45, 0.75, 1.0],
        transform: GradientRotation(start),
      ).createShader(rect);

    canvas.drawArc(rect, start, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerRingPainter old) =>
      old.progress != progress || old.c1 != c1 || old.c2 != c2;
}
