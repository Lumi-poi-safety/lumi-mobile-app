import 'package:flutter/material.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final _pc = PageController();
  int _index = 0;

  final _pages = const <_WalkPage>[
    // WT1 — Intro
    _WalkPage(
      imageAsset: 'lib/assets/images/Lumi_f2.png',
      title: "Hi, I’m Lumi,\nYour safety genie",
      body: "I help you choose places with safety in mind - using recent crime patterns nearby.",
      cta: "Next",
    ),

    // WT2 — Crime safety framing
    _WalkPage(
      imageAsset: 'lib/assets/images/walk_map.jpg',
      title: "Safety matters - even when choosing a place",
      body:
          "Lumi helps you discover places while taking recent crime activity in the area into account.",
      cta: "Got it",
    ),

    // WT3 — Pins meaning
    _WalkPage(
      imageAsset: 'lib/assets/images/all_pins_rows.png',
      title: "Not all places feel the same",
      body:
          "Lumi highlights what to expect around each place - from generally calm areas to places that may need extra awareness.",
      cta: "Makes sense",
    ),

    // WT4 — How to use
    _WalkPage(
      imageAsset: 'lib/assets/images/needs.png',
      title: "Tell Lumi what you need",
      body:
          "Search for a place, choose who you’re going with, and decide how cautious you want to be.\nLumi adapts recommendations to your needs.",
      cta: "Let’s try it",
    ),

    // WT5 — Trust & transparency
    _WalkPage(
      imageAsset: 'lib/assets/images/lumi_police2.png',
      title: 'Clear guidance, not guarantees',
      body:
          'Lumi shows patterns based on available data.\nSafety can change, and the final choice is always yours.',
      cta: 'Start exploring',
    ),
  ];

  bool get _isLast => _index == _pages.length - 1;

  void _next() {
    if (_isLast) {
      Navigator.of(context).pushReplacementNamed(Routes.onboardIntro);
      return;
    }
    _pc.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pc,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                    child: Column(
                      children: [
                        Expanded(flex: 7, child: _WalkthroughVisual(asset: p.imageAsset)),
                        const SizedBox(height: 18),

                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                p.title,
                                textAlign: TextAlign.center,
                                style: t.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                p.body,
                                textAlign: TextAlign.center,
                                style: t.bodyLarge?.copyWith(color: Colors.black54, height: 1.35),
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

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Dots(count: _pages.length, index: _index),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: LumiPrimaryButton(onPressed: _next, label: _pages[_index].cta),
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
