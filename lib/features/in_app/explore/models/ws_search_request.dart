class WsSearchRequest {
  final String requestId;
  final String query;
  final String? withWhom;
  final String? caution;
  final double? lat;
  final double? lng;

  WsSearchRequest({
    required this.requestId,
    required this.query,
    this.withWhom,
    this.caution,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() => {
    "type": "search_request",
    "requestId": requestId,
    "query": query,
    "context": {"withWhom": withWhom, "caution": caution},
    "location": (lat != null && lng != null) ? {"lat": lat, "lng": lng} : null,
  }..removeWhere((k, v) => v == null);
}

class WsSearchResult {
  final String requestId;
  final bool isFinal;
  final List<Map<String, dynamic>> pois;

  WsSearchResult({required this.requestId, required this.isFinal, required this.pois});

  static WsSearchResult fromJson(Map<String, dynamic> j) => WsSearchResult(
    requestId: j["requestId"] as String,
    isFinal: (j["isFinal"] as bool?) ?? false,
    pois: (j["pois"] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>(),
  );
}
