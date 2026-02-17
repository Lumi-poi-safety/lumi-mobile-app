import 'package:flutter/material.dart';

class SafetyMattersPage extends StatelessWidget {
  const SafetyMattersPage({super.key, this.onGotIt, this.pageIndex = 0, this.pageCount = 4});

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
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.asset('lib/assets/images/walk_map.jpg', fit: BoxFit.cover),
              ),
            ),

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
