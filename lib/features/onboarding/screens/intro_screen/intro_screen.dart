import 'package:flutter/material.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class OnboardIntroScreen extends StatelessWidget {
  const OnboardIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFFFEFEFE),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  "lib/assets/images/Lumi_f2.png",
                  // width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),

              // // Optional: show Lumi image here too
              // Image.asset(
              //   'assets/lumi/lumi.png', // change to your actual Lumi asset
              //   width: 120,
              //   height: 120,
              //   errorBuilder: (_, __, ___) => const SizedBox(height: 120),
              // ),
              const SizedBox(height: 18),
              Text(
                "Let’s get to know each other",
                textAlign: TextAlign.center,
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                "A few quick details help me personalize your recommendations.",
                textAlign: TextAlign.center,
                style: t.bodyLarge?.copyWith(
                  color: Colors.black54,
                  height: 1.35,
                ),
              ),

              const Spacer(),

              Text(
                "I only store localy on your device, and use anonymous data to improve my suggestions.",
                textAlign: TextAlign.center,
                style: t.bodySmall?.copyWith(color: Colors.black45),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: LumiPrimaryButton(
                  label: "Let’s start",
                  onPressed: () => Navigator.of(
                    context,
                  ).pushReplacementNamed(Routes.onboardName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
