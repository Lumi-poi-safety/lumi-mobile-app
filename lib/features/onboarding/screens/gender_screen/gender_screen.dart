import 'package:flutter/material.dart';
import 'package:lumi/data/local/user_profile_store.dart';
import 'package:lumi/models/user_profile.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/style/age_buttons_style.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _store = UserProfileStore();
  Gender? _selected;
  bool _loading = true;

  final _options = const [
    (Gender.female, 'She', "lib/assets/images/female.png"),
    (Gender.male, 'He', "lib/assets/images/male.png"),
    (Gender.they, 'They', "lib/assets/images/they.png"),
    (Gender.preferNot, 'Prefer not to say', "lib/assets/images/just_me.png"),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final p = await _store.load();
    setState(() {
      _selected = p.gender;
      _loading = false;
    });
  }

  Future<void> _done() async {
    await _store.saveGender(_selected);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.main, (_) => false);
  }

  Future<void> _skip() async {
    setState(() => _selected = Gender.preferNot);
    await _done();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

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
                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0XFFFEFEFE)),
                alignment: Alignment.center,
                child: Image.asset("lib/assets/images/Lumi_f2.png"),
              ),
              const SizedBox(height: 30),
              Text(
                "How would you like to be identified?",
                style: t.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                childAspectRatio: 1.5,
                physics: const NeverScrollableScrollPhysics(),
                children: _options.map((e) {
                  final isSelected = _selected == e.$1;
                  return SizedBox(
                    width: double.infinity,
                    child: isSelected
                        ? ElevatedButton(
                            onPressed: () => setState(() => _selected = e.$1),
                            style: LumiAgeButtonStyles.selected.copyWith(),
                            child: _buttonContent(e),
                          )
                        : OutlinedButton(
                            onPressed: () => setState(() => _selected = e.$1),
                            style: LumiAgeButtonStyles.unselected,
                            child: _buttonContent(e),
                          ),
                  );
                }).toList(),
              ),

              const Spacer(),
              LumiPrimaryButton(onPressed: _selected == null ? null : _done, label: "Done"),
              const SizedBox(height: 12),
              TextButton(onPressed: _skip, child: const Text("Skip")),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonContent((Gender, String, String) e) {
    return Column(
      children: [
        Expanded(child: Image.asset(e.$3, fit: BoxFit.contain)),
        Text(e.$2),
        SizedBox(height: 8),
      ],
    );
  }
}
