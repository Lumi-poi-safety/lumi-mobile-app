import 'package:flutter/material.dart';
import 'package:lumi/features/in_app/widgets/lumi_app_bar.dart';
import '../../../../data/local/user_profile_store.dart';
import '../../../../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _store = UserProfileStore();
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await _store.load();
    if (!mounted) return;
    setState(() => _profile = p);
  }

  String _ageLabel(AgeRange? a) {
    switch (a) {
      case AgeRange.r18_24:
        return "18–24";
      case AgeRange.r25_34:
        return "25–34";
      case AgeRange.r35_44:
        return "35–44";
      case AgeRange.r45_54:
        return "45–54";
      case AgeRange.r55Plus:
        return "55+";
      case AgeRange.preferNot:
        return "Prefer not to say";
      case null:
        return "—";
    }
  }

  String _genderLabel(Gender? s) {
    switch (s) {
      case Gender.female:
        return "She";
      case Gender.male:
        return "He";
      case Gender.they:
        return "They";
      case Gender.preferNot:
        return "Prefer not to say";
      case null:
        return "—";
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: lumiAppBar('Profile'),
      body: _profile == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _profile!.name == null
                        ? "Hello."
                        : "Hello, ${_profile!.name}.",
                    style: t.titleLarge,
                  ),
                  const SizedBox(height: 18),

                  _Row(label: "Age", value: _ageLabel(_profile!.ageRange)),
                  const SizedBox(height: 10),
                  _Row(
                    label: "Identified as",
                    value: _genderLabel(_profile!.gender),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    "Saved locally.",
                    style: t.bodyMedium?.copyWith(color: Colors.black54),
                  ),

                  const Spacer(),
                  OutlinedButton(
                    onPressed: _load,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.55)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
