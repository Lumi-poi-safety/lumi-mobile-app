import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_profile.dart';

class UserProfileStore {
  static const _kName = 'profile.name';
  static const _kAge = 'profile.ageRange';
  static const _kGender = 'profile.gender';

  Future<UserProfile> load() async {
    final sp = await SharedPreferences.getInstance();
    final name = sp.getString(_kName);
    final ageStr = sp.getString(_kAge);
    final genderStr = sp.getString(_kGender);

    return UserProfile(
      name: (name == null || name.trim().isEmpty) ? null : name,
      ageRange: _ageFromString(ageStr),
      gender: _genderFromString(genderStr),
    );
  }

  Future<void> saveName(String? name) async {
    final sp = await SharedPreferences.getInstance();
    final v = (name ?? '').trim();
    if (v.isEmpty) {
      await sp.remove(_kName);
    } else {
      await sp.setString(_kName, v);
    }
  }

  Future<void> saveAgeRange(AgeRange? ageRange) async {
    final sp = await SharedPreferences.getInstance();
    if (ageRange == null) {
      await sp.remove(_kAge);
    } else {
      await sp.setString(_kAge, ageRange.name);
    }
  }

  Future<void> saveGender(Gender? gender) async {
    final sp = await SharedPreferences.getInstance();
    if (gender == null) {
      await sp.remove(_kGender);
    } else {
      await sp.setString(_kGender, gender.name);
    }
  }

  AgeRange? _ageFromString(String? s) {
    if (s == null) return null;
    return AgeRange.values.where((e) => e.name == s).firstOrNull;
  }

  Gender? _genderFromString(String? s) {
    if (s == null) return null;
    return Gender.values.where((e) => e.name == s).firstOrNull;
  }
}

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
