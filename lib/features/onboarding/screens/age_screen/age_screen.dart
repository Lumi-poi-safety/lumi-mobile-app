import 'package:flutter/material.dart';
import 'package:lumi/data/local/user_profile_store.dart';
import 'package:lumi/models/user_profile.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/style/age_buttons_style.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final _store = UserProfileStore();
  AgeRange? _selected;
  bool _loading = true;

  final _options = const [
    (AgeRange.r18_24, '18–24'),
    (AgeRange.r25_34, '25–34'),
    (AgeRange.r35_44, '35–44'),
    (AgeRange.r45_54, '45–54'),
    (AgeRange.r55Plus, '55+'),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final p = await _store.load();
    setState(() {
      _selected = p.ageRange;
      _loading = false;
    });
  }

  Future<void> _continue() async {
    // allow skip -> null
    await _store.saveAgeRange(_selected);
    if (!mounted) return;
    Navigator.of(context).pushNamed(Routes.onboardSex);
  }

  Future<void> _preferNot() async {
    setState(() => _selected = AgeRange.preferNot);
  }

  Future<void> _skip() async {
    setState(() => _selected = null);
    await _continue();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (_loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFFFEFEFE),
                ),
                alignment: Alignment.center,
                child: Image.asset("lib/assets/images/Lumi_f2.png"),
              ),
              const SizedBox(height: 30),
              Text("What’s your age?", style: t.titleLarge),
              const SizedBox(height: 50),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: LumiAgeButtonStyles.height,
                ),
                itemBuilder: (context, i) {
                  final age = _options[i];
                  final selected = _selected == _options[i].$1;

                  return SizedBox(
                    width: double.infinity,
                    child: selected
                        ? ElevatedButton(
                            onPressed: () => setState(() => _selected = age.$1),
                            style: LumiAgeButtonStyles.selected,
                            child: Text(age.$2),
                          )
                        : OutlinedButton(
                            onPressed: () => setState(() => _selected = age.$1),
                            style: LumiAgeButtonStyles.unselected,
                            child: Text(age.$2),
                          ),
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _preferNot,
                  style: _selected == AgeRange.preferNot
                      ? LumiAgeButtonStyles.selected
                      : LumiAgeButtonStyles.unselected,
                  child: const Text("Prefer not to say"),
                ),
              ),

              const Spacer(),
              LumiPrimaryButton(onPressed: _continue, label: "Continue"),
              const SizedBox(height: 12),
              TextButton(onPressed: _skip, child: const Text("Skip")),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
