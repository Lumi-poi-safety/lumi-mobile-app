enum VisitWith { justMe, friends, date, family }

enum CautionLevel { relaxed, balanced, cautious }

class VisitContext {
  final VisitWith? withWhom;
  final CautionLevel? caution;

  const VisitContext({this.withWhom, this.caution});

  bool get isEmpty => withWhom == null && caution == null;

  VisitContext copyWith({VisitWith? withWhom, CautionLevel? caution}) {
    return VisitContext(
      withWhom: withWhom ?? this.withWhom,
      caution: caution ?? this.caution,
    );
  }
}
