import 'package:flutter/material.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class SafetyMattersPage extends StatelessWidget {
  const SafetyMattersPage({
    super.key,
    this.onGotIt,
    this.pageIndex = 0,
    this.pageCount = 4,
  });

  final VoidCallback? onGotIt;
  final int pageIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: _RoundedCard(
        child: Stack(
          children: [
            // Background map image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.asset(
                  'lib/assets/images/walk_map.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Soft white overlay (to get that washed-out look)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.95),
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.95),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Title
            Positioned(
              top: 0,
              left: 22,
              right: 22,
              child: Text(
                "Safety matters -\neven when choosing\na place",
                textAlign: TextAlign.center,
                style: t.titleMedium,
              ),
            ),

            // Pins (positions tuned to resemble your mock)
            // Swap these assets with your actual pin PNGs (transparent).
            // _Pin(
            //   asset: 'assets/walkthrough/pin_green.png',
            //   top: 165,
            //   left: 200,
            //   size: 44,
            // ),
            // _Pin(
            //   asset: 'assets/walkthrough/pin_yellow.png',
            //   top: 210,
            //   right: 85,
            //   size: 44,
            // ),
            // _Pin(
            //   asset: 'assets/walkthrough/pin_blue.png',
            //   top: 265,
            //   left: 95,
            //   size: 46,
            // ),
            // _Pin(
            //   asset: 'assets/walkthrough/pin_orange.png',
            //   top: 325,
            //   left: 175,
            //   size: 50,
            // ),
            // _Pin(
            //   asset: 'assets/walkthrough/pin_purple.png',
            //   top: 330,
            //   left: 60,
            //   size: 34,
            // ),

            // Lumi at bottom center
            // Positioned(
            //   left: 0,
            //   // right: 0,
            //   // bottom: 2000,
            //   child: Center(
            //     child: Image.asset(
            //       'lib/assets/images/Lumi_f.png',
            //       height: 160,
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 10,
              left: 22,
              right: 22,
              child: Text(
                "Lumi helps you discover places while taking recent crime activity in the area into account.",
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
            ),
            // Bottom button
            // Positioned(
            //   left: 18,
            //   right: 18,
            //   bottom: 58,
            //   child: LumiPrimaryButton(label: "Got it", onPressed: onGotIt),
            // ),

            // Page dots
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   bottom: 18,
            //   child: Center(
            //     child: _DotsIndicator(
            //       count: pageCount,
            //       index: pageIndex,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _RoundedCard extends StatelessWidget {
  const _RoundedCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 720,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(26), child: child),
    );
  }
}
