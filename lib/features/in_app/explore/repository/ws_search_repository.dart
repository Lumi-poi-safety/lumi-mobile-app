import 'dart:async';

import 'package:lumi/features/in_app/explore/models/ws_search_request.dart';
import 'package:lumi/features/in_app/explore/service/ws_client.dart';

class SearchWsRepository {
  final WsClient _client;

  SearchWsRepository(this._client);

  Stream<WsSearchResult> resultsForRequest(String requestId) {
    return _client.messages
        .where(
          (m) => m["type"] == "search_result" && m["requestId"] == requestId,
        )
        .map((m) => WsSearchResult.fromJson(m));
  }

  Stream<String> errorsForRequest(String requestId) {
    return _client.messages
        .where((m) => m["type"] == "error" && m["requestId"] == requestId)
        .map((m) => (m["message"] as String?) ?? "Unknown error");
  }

  Future<void> ensureConnected() => _client.connect();

  void sendSearch(WsSearchRequest req) => _client.send(req.toJson());

  void cancel(String requestId) =>
      _client.send({"type": "cancel_request", "requestId": requestId});
}
