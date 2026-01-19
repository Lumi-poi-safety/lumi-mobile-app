import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsClient {
  final Uri uri;

  WebSocketChannel? _ch;
  StreamSubscription? _sub;

  final _incoming = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messages => _incoming.stream;

  bool get isConnected => _ch != null;

  WsClient(this.uri);

  Future<void> connect() async {
    if (_ch != null) return;

    _ch = WebSocketChannel.connect(uri);
    _sub = _ch!.stream.listen(
      (event) {
        try {
          final j = jsonDecode(event as String) as Map<String, dynamic>;
          _incoming.add(j);
        } catch (_) {
          // ignore malformed messages
        }
      },
      onError: (_) => _handleDisconnected(),
      onDone: _handleDisconnected,
      cancelOnError: true,
    );
  }

  void send(Map<String, dynamic> json) {
    final ch = _ch;
    if (ch == null) return;
    ch.sink.add(jsonEncode(json));
  }

  Future<void> close() async {
    await _sub?.cancel();
    _sub = null;
    await _ch?.sink.close();
    _ch = null;
  }

  void _handleDisconnected() {
    // mark disconnected; reconnection handled by caller/viewmodel
    _sub?.cancel();
    _sub = null;
    _ch = null;
  }
}
