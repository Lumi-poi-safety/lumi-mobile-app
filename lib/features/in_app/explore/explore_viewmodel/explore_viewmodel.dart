import 'dart:async';
import 'package:lumi/features/in_app/explore/models/ws_search_request.dart';
import 'package:lumi/features/in_app/explore/repository/ws_search_repository.dart';
import 'package:uuid/uuid.dart';

class SearchFlowVm {
  final SearchWsRepository repo;
  final _uuid = const Uuid();

  SearchFlowVm(this.repo);

  String newRequestId() => _uuid.v4();

  Future<String> startSearch({
    required String query,
    required String? withWhom,
    required String? caution,
    double? lat,
    double? lng,
  }) async {
    await repo.ensureConnected();
    final requestId = newRequestId();

    repo.sendSearch(
      WsSearchRequest(
        requestId: requestId,
        query: query,
        withWhom: withWhom,
        caution: caution,
        lat: lat,
        lng: lng,
      ),
    );

    return requestId;
  }
}
