import 'package:flutter/material.dart';
import 'package:lumi/data/local/user_profile_store.dart';
import 'package:lumi/di/di.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';
import 'package:lumi/features/in_app/widgets/lumi_app_bar.dart';
import 'package:lumi/models/user_profile.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/style/age_buttons_style.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  final _queryCtrl = TextEditingController();
  VisitWith? _withWhom;
  CautionLevel? _caution;

  final _store = UserProfileStore();
  UserProfile? _profile;
  String? _name;

  bool get _canSearch => _queryCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _queryCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final p = await _store.load();
    if (!mounted) return;
    if (p.name != null && p.name!.isNotEmpty) {
      _name = p.name;
    }
    setState(() => _profile = p);
  }

  void _search() async {
    FocusScope.of(context).unfocus();
    final query = _queryCtrl.text.trim();
    final ctx = VisitContext(withWhom: _withWhom, caution: _caution);

    searchBloc.search(userText: query, visitContext: ctx);

    Navigator.of(context).pushNamed(
      Routes.mapResults,
      arguments: MapResultsArgs(query: query, context: ctx),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: lumiAppBar("What are you looking for?"),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextField(
                          controller: _queryCtrl,
                          decoration: const InputDecoration(
                            hintText: "Cafe, pharmacy, park, pizza…",
                            prefixIcon: Icon(Icons.search),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _canSearch ? _search() : null,
                        ),

                        const SizedBox(height: 18),
                        Text(
                          "Who are you going with?",
                          style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),

                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          childAspectRatio: 1.5,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _companyButton(
                              "Just me",
                              VisitWith.justMe,
                              "lib/assets/images/just_me.png",
                            ),
                            _companyButton(
                              "Friends",
                              VisitWith.friends,
                              "lib/assets/images/friends.png",
                            ),
                            _companyButton(
                              "Date",
                              VisitWith.date,
                              "lib/assets/images/romantic_r.png",
                            ),
                            _companyButton(
                              "Family",
                              VisitWith.family,
                              "lib/assets/images/family.png",
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Choose your safety level for this visit",
                          style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),

                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          childAspectRatio: 1.1,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _safetyButton(
                              "Relaxed",
                              CautionLevel.relaxed,
                              "lib/assets/images/relaxed.png",
                            ),
                            _safetyButton(
                              "Balanced",
                              CautionLevel.balanced,
                              "lib/assets/images/balanced.png",
                            ),
                            _safetyButton(
                              "Cautious",
                              CautionLevel.cautious,
                              "lib/assets/images/cautious.png",
                            ),
                          ],
                        ),

                        SizedBox(height: 18),
                        LumiPrimaryButton(
                          onPressed: _canSearch ? _search : null,
                          label: "Find places",
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _companyButton(String label, VisitWith withWhom, String image) {
    return SizedBox(
      width: double.infinity,
      child: _withWhom == withWhom
          ? ElevatedButton(
              onPressed: () => setState(() => _withWhom = withWhom),
              style: LumiAgeButtonStyles.selected.copyWith(),
              child: _companyButtonContent(label, image),
            )
          : OutlinedButton(
              onPressed: () => setState(() => _withWhom = withWhom),
              style: LumiAgeButtonStyles.unselected,
              child: _companyButtonContent(label, image),
            ),
    );
  }

  Widget? _companyButtonContent(String label, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, fit: BoxFit.contain, height: MediaQuery.of(context).size.width * 0.2),
        Text(label),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _safetyButton(String label, CautionLevel cautionLevel, String image) {
    return SizedBox(
      width: double.infinity,
      child: _caution == cautionLevel
          ? ElevatedButton(
              onPressed: () => setState(() => _caution = cautionLevel),
              style: LumiAgeButtonStyles.selected.copyWith(),
              child: _safetyButtonContent(label, image),
            )
          : OutlinedButton(
              onPressed: () => setState(() => _caution = cautionLevel),
              style: LumiAgeButtonStyles.unselected,
              child: _safetyButtonContent(label, image),
            ),
    );
  }

  Widget? _safetyButtonContent(String label, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, fit: BoxFit.contain, height: MediaQuery.of(context).size.width * 0.15),
        Text(label),
        SizedBox(height: 5),
      ],
    );
  }
}

class MapResultsArgs {
  final String query;
  final VisitContext context;
  const MapResultsArgs({required this.query, required this.context});
}
