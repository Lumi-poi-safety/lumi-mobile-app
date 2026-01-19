enum Gender { male, female, they, preferNot }

enum AgeRange { r18_24, r25_34, r35_44, r45_54, r55Plus, preferNot }

class UserProfile {
  final String? name;
  final Gender? gender;
  final AgeRange? ageRange;

  const UserProfile({this.name, this.gender, this.ageRange});

  bool get isComplete => ageRange != null && gender != null;

  UserProfile copyWith({String? name, Gender? gender, AgeRange? ageRange}) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
    );
  }
}
