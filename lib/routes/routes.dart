import 'package:flutter/material.dart';
import 'package:lumi/data/local/user_profile_store.dart';
import 'package:lumi/features/in_app/explore/explore_screen/map_results_screen.dart';
import 'package:lumi/features/in_app/main_nav_bar/main_nav_bar.dart';
import 'package:lumi/features/onboarding/screens/age_screen/age_screen.dart';
import 'package:lumi/features/onboarding/screens/gender_screen/gender_screen.dart';
import 'package:lumi/features/onboarding/screens/intro_screen/intro_screen.dart';
import 'package:lumi/features/onboarding/screens/name_screen/name_screen.dart';
import 'package:lumi/features/onboarding/screens/welcome_screen/welcome_screen.dart';
import 'package:lumi/features/walkthrough/walkthrough_screen/walkthrough_screen.dart';
import 'package:lumi/features/walkthrough/walkthrough_screen/walkthrough_screen_first%20copy.dart';
import 'package:lumi/models/user_profile.dart';

class Routes {
  static const entry = '/';
  static const walkthrough = '/walkthrough';
  static const walkthroughFirst = '/walkthrough_first';
  static const onboardWelcome = '/onboarding/welcome';
  static const onboardIntro = '/onboarding/intro';
  static const onboardName = '/onboarding/name';
  static const onboardAge = '/onboarding/age';
  static const onboardSex = '/onboarding/sex';
  static const main = '/main';
  static const mapResults = '/results/map';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.entry: (_) => const EntryRouter(),
  Routes.walkthroughFirst: (_) =>
      const WalkthroughScreenFirstCopy(nextRoute: Routes.onboardWelcome),
  Routes.walkthrough: (_) => const WalkthroughScreen(),
  Routes.onboardIntro: (_) => const OnboardIntroScreen(),
  Routes.onboardWelcome: (_) => const WelcomeScreen(),
  Routes.onboardName: (_) => const NameScreen(),
  Routes.onboardAge: (_) => const AgeScreen(),
  Routes.onboardSex: (_) => const GenderScreen(),
  Routes.main: (_) => const MainNavBar(),
  Routes.mapResults: (_) => const MapResultsScreen(),
};

class EntryRouter extends StatefulWidget {
  const EntryRouter({super.key});

  @override
  State<EntryRouter> createState() => _EntryRouterState();
}

class _EntryRouterState extends State<EntryRouter> {
  final _store = UserProfileStore();

  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final UserProfile p = await _store.load();
    if (!mounted) return;

    final next = p.isComplete ? Routes.main : Routes.walkthrough;

    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
