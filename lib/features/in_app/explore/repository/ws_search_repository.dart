import 'package:lumi/features/in_app/explore/models/results_dto.dart';
import 'package:lumi/features/in_app/explore/service/ws_client.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';
import 'package:lumi/models/user_profile.dart';
import 'package:uuid/uuid.dart';

class SearchWsRepository {
  final WsClient _client;
  final _uuid = const Uuid();

  SearchWsRepository(this._client);

  Future<List<PoiWsResult>> ask({
    required String userText,
    required VisitContext visitContext,
    String? requestIdOverride,
    required UserProfile userProfile,
    required String locationName,
    required double userLat,
    required double userLng,
  }) async {
    await _client.connect();

    final requestId = requestIdOverride ?? _uuid.v4();

    _client.connect();

    _client.sendQuestion(
      requestId: requestId,
      userText: userText,
      context: {
        "ntaName": locationName,
        "userLat": userLat,
        "userLng": userLng,
        "ageRange": userProfile.ageRange == AgeRange.preferNot ? null : userProfile.ageRange?.value,
        "gender": userProfile.gender == Gender.preferNot
            ? null
            : userProfile.gender?.value.toLowerCase(),
        "visitWith": visitContext.withWhom?.beValue.toLowerCase(),
        "cautiousness": visitContext.caution?.value.toLowerCase(),
        "requestedPoiCount": 10,
      },
    );

    final data = await _client.waitForDone(requestId: requestId);

    final poisRaw = (data["pois"] as List<dynamic>? ?? const []);
    return poisRaw.whereType<Map<String, dynamic>>().map(PoiWsResult.fromJson).toList();
  }
}
