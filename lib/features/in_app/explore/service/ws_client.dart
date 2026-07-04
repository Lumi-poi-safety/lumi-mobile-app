import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WsClient {
  static const String wsUrl = YOUR_WEBSOCKET_URL_HERE; // Replace with your WebSocket URL

  WebSocketChannel? _channel;
  StreamSubscription? _sub;

  final _incoming = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messages => _incoming.stream;

  bool get isConnected => _channel != null;

  Future<void> connect() async {
    if (_channel != null) return;

    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _sub = _channel!.stream.listen(
      (event) {
        if (event is! String) return;
        try {
          final decoded = jsonDecode(event);
          if (decoded is Map<String, dynamic>) {
            _incoming.add(decoded);
          }
        } catch (_) {}
      },
      onDone: _markDisconnected,
      onError: (_) => _markDisconnected(),
      cancelOnError: true,
    );
  }

  void _markDisconnected() {
    _sub?.cancel();
    _sub = null;
    _channel = null;
  }

  void sendEvent(String event, Map<String, dynamic> data) {
    final ch = _channel;
    if (ch == null) throw StateError('WS not connected. Call connect() first.');

    final payload = <String, dynamic>{"event": event, "data": data};
    ch.sink.add(jsonEncode(payload));
  }

  void sendQuestion({
    required String requestId,
    required String userText,
    required Map<String, dynamic> context,
  }) {
    print("requestId: $requestId");
    print("userText: $userText");
    print("context: $context");
    sendEvent("question", {"requestId": requestId, "userText": userText, "context": context});
  }

  Future<Map<String, dynamic>> waitForDone({
    required String requestId,
    Duration timeout = const Duration(seconds: 250),
  }) async {
    await connect();

    final stream = messages.where((m) {
      print(m);
      if (m["event"] != "done" && m["event"] != "error") return false;
      final data = m["data"];
      if (data is! Map<String, dynamic>) return false;
      return data["requestId"] == requestId;
    });

    try {
      final msg = await stream.first.timeout(timeout);
      final event = msg["event"] as String?;
      final data = (msg["data"] as Map).cast<String, dynamic>();

      if (event == "done") {
        return data;
      }

      // event == "error"
      final message = (data["message"] ?? data["error"] ?? "Unknown error").toString();
      throw WsRequestException(requestId: requestId, message: message, raw: data);
    } on TimeoutException {
      throw TimeoutException('Timed out waiting for done for requestId=$requestId');
    }
  }

  Future<void> close() async {
    await _sub?.cancel();
    _sub = null;
    await _channel?.sink.close();
    _channel = null;
  }
}

class WsRequestException implements Exception {
  final String requestId;
  final String message;
  final Map<String, dynamic> raw;

  WsRequestException({required this.requestId, required this.message, required this.raw});

  @override
  String toString() => 'WsRequestException(requestId=$requestId, message=$message)';
}
