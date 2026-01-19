import 'package:flutter/material.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class WalkthroughScreenFirst extends StatefulWidget {
  /// Set false to remove screen 4 (trust & transparency).
  final bool includeTrustScreen;

  /// Where to go after walkthrough (e.g. onboarding welcome route).
  final String nextRoute;

  const WalkthroughScreenFirst({
    super.key,
    required this.nextRoute,
    this.includeTrustScreen = true,
  });

  @override
  State<WalkthroughScreenFirst> createState() => _WalkthroughScreenFirstState();
}

class _WalkthroughScreenFirstState extends State<WalkthroughScreenFirst> {
  final _controller = PageController();
  int _index = 0;

  List<_WalkPage> get _pages {
    final base = <_WalkPage>[
      const _WalkPage(
        imageAsset: 'lib/assets/images/walk_map.jpg',
        title: 'Safety matters - even when choosing a place',
        body:
            'Lumi helps you discover places while taking recent crime activity in the area into account.',
        cta: 'Got it',
      ),
      const _WalkPage(
        imageAsset: 'lib/assets/images/walk_map.jpg',
        title: 'Not all places feel the same',
        body:
            'Lumi highlights what to expect around each place - from generally calm areas to places that may need extra awareness.',
        cta: 'Makes sense',
      ),
      const _WalkPage(
        imageAsset: 'lib/assets/images/walk_map.jpg',
        title: 'Tell Lumi what you need',
        body:
            'Search for a place, choose who you’re going with, and decide how cautious you want to be.\nLumi adapts recommendations to your context.',
        cta: 'Let’s try it',
      ),
    ];

    if (widget.includeTrustScreen) {
      base.add(
        const _WalkPage(
          imageAsset: 'lib/assets/images/walk_map.jpg',
          title: 'Clear guidance, not guarantees',
          body:
              'Lumi shows patterns based on available data.\nSafety can change, and the final choice is always yours.',
          cta: 'Start exploring',
        ),
      );
    }

    return base;
  }

  bool get _isLast => _index == _pages.length - 1;

  void _goNext() {
    if (_isLast) {
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  // void _goBack() {
  //   if (_index == 0) return;
  //   _controller.previousPage(
  //     duration: const Duration(milliseconds: 260),
  //     curve: Curves.easeOut,
  //   );
  // }

  // void _skip() {
  //   Navigator.of(context).pushReplacementNamed(widget.nextRoute);
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: Back + Skip
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            //   child: Row(
            //     children: [
            //       IconButton(
            //         onPressed: _index == 0 ? null : _goBack,
            //         icon: const Icon(Icons.arrow_back),
            //         tooltip: 'Back',
            //       ),
            //       const Spacer(),
            //       TextButton(onPressed: _skip, child: const Text('Skip')),
            //     ],
            //   ),
            // ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                    child: Column(
                      children: [
                        // Visual
                        Expanded(
                          flex: 6,
                          child: _WalkthroughVisual(asset: p.imageAsset),
                        ),
                        const SizedBox(height: 18),

                        // Copy
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                p.title,
                                textAlign: TextAlign.center,
                                style: t.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                p.body,
                                textAlign: TextAlign.center,
                                style: t.bodyLarge?.copyWith(
                                  color: Colors.black54,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Dots(count: _pages.length, index: _index),
            ),

            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: LumiPrimaryButton(
                  onPressed: _goNext,
                  label: _pages[_index].cta,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalkPage {
  final String imageAsset;
  final String title;
  final String body;
  final String cta;

  const _WalkPage({
    required this.imageAsset,
    required this.title,
    required this.body,
    required this.cta,
  });
}

class _WalkthroughVisual extends StatelessWidget {
  final String asset;
  const _WalkthroughVisual({required this.asset});

  @override
  Widget build(BuildContext context) {
    // A clean card-like container that matches your soft Lumi style
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Center(
          child: Text(
            'Missing asset:\n$asset',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black.withOpacity(0.45)),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: selected ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? Colors.black87 : Colors.black26,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
