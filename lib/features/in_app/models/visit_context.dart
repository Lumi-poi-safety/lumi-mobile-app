enum VisitWith {
  justMe('Just me', 'alone'),
  friends('Friends', 'friends'),
  date('Date', 'date'),
  family('Family', 'family');

  const VisitWith(this.value, this.beValue);
  final String value;
  final String beValue;
}

enum CautionLevel {
  relaxed('Relaxed'),
  balanced('Balanced'),
  cautious('Cautious');

  const CautionLevel(this.value);
  final String value;
}

class VisitContext {
  final VisitWith? withWhom;
  final CautionLevel? caution;

  const VisitContext({this.withWhom, this.caution});

  bool get isEmpty => withWhom == null && caution == null;

  VisitContext copyWith({VisitWith? withWhom, CautionLevel? caution}) {
    return VisitContext(withWhom: withWhom ?? this.withWhom, caution: caution ?? this.caution);
  }
}
