class PoiWsResult {
  final String name;
  final double lat;
  final double lng;
  final String safetyLevel;
  final String safetyReason;
  final String relevanceReason;

  const PoiWsResult({
    required this.name,
    required this.lat,
    required this.lng,
    required this.safetyLevel,
    required this.safetyReason,
    required this.relevanceReason,
  });

  factory PoiWsResult.fromJson(Map<String, dynamic> j) => PoiWsResult(
    name: j["name"] as String,
    lat: (j["lat"] as num).toDouble(),
    lng: (j["lng"] as num).toDouble(),
    safetyLevel: (j["safetyLevel"] as String?) ?? "unknown",
    safetyReason: (j["safetyReason"] as String?) ?? "",
    relevanceReason: (j["relevanceReason"] as String?) ?? "",
  );
}
