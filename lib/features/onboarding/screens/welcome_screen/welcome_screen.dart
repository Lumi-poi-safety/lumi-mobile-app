import 'package:flutter/material.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          child: Column(
            children: [
              const Spacer(flex: 1),

              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0XFFFEFEFE)),
                alignment: Alignment.center,
                child: Image.asset("lib/assets/images/Lumi_f2.png"),
              ),

              const SizedBox(height: 24),
              Text(
                "Hi, I’m Lumi",
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.normal, letterSpacing: 0.3),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Your safety genie.",
                style: t.titleLarge?.copyWith(
                  fontSize: 20,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Let's get to know each other a little so I can give you the best recommendations.",
                  style: t.bodyMedium?.copyWith(color: Colors.black54, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 4),
              Text(
                "I only store localy on your device, and use anonymous data to improve my suggestions.",
                style: t.bodySmall?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),
              LumiPrimaryButton(
                onPressed: () => Navigator.of(context).pushNamed(Routes.onboardName),
                label: "Let’s start",
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
