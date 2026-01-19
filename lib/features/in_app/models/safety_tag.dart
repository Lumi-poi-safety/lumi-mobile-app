enum SafetyTag { generallySafe, beCautious, caution, noData }

extension SafetyTagX on SafetyTag {
  String get label {
    switch (this) {
      case SafetyTag.generallySafe:
        return "Generally safe";
      case SafetyTag.beCautious:
        return "Be cautious";
      case SafetyTag.caution:
        return "Caution";
      case SafetyTag.noData:
        return "No data";
    }
  }

  String get marker {
    switch (this) {
      case SafetyTag.generallySafe:
        return "lib/assets/images/green_pin.png";
      case SafetyTag.beCautious:
        return "lib/assets/images/yellow_pin.png";
      case SafetyTag.caution:
        return "lib/assets/images/red_pin.png";
      case SafetyTag.noData:
        return "lib/assets/images/grey_pin.png";
    }
  }
}
