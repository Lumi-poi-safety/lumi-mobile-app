enum Gender {
  male('Male'),
  female('Female'),
  they('They'),
  preferNot('Prefer not to say');

  const Gender(this.value);
  final String value;
}

enum AgeRange {
  r18_24('18-24'),
  r25_34('25-34'),
  r35_44('35-44'),
  r45_54('45-54'),
  r55Plus('55+'),
  preferNot('Prefer not to say');

  const AgeRange(this.value);

  final String value;
}

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
