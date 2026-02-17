import 'package:lumi/data/local/user_profile_store.dart';
import 'package:lumi/features/in_app/explore/models/demo_nta_location.dart';
import 'package:lumi/features/in_app/explore/repository/demo_location_repository.dart';
import 'package:lumi/features/in_app/explore/repository/ws_search_repository.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'search_state.dart';

class SearchBloc {
  final SearchWsRepository _repo;
  final DemoLocationRepository _demoLocationRepo;
  final _uuid = const Uuid();

  final BehaviorSubject<SearchState> _state = BehaviorSubject.seeded(const SearchIdle());
  Stream<SearchState> get state$ => _state.stream;
  SearchState get state => _state.value;

  final BehaviorSubject<DemoNtaLocation?> _location = BehaviorSubject.seeded(null);
  Stream<DemoNtaLocation?> get location$ => _location.stream;
  DemoNtaLocation? get location => _location.valueOrNull;

  String? _activeRequestId;

  SearchBloc(this._repo, this._demoLocationRepo);

  Future<void> initDemoLocation() async {
    if (_location.valueOrNull != null) return;
    _location.add(await _demoLocationRepo.pickRandom());
    print("miri: added location");
  }

  Future<void> pickNewDemoLocation() async {
    _location.add(await _demoLocationRepo.pickRandom());
  }

  Future<void> search({
    required String userText,
    required VisitContext visitContext,
    bool randomizeLocation = true,
  }) async {
    final requestId = _uuid.v4();
    _activeRequestId = requestId;

    _state.add(SearchLoading(requestId));

    final p = await UserProfileStore().load();

    try {
      if (randomizeLocation) {
        await pickNewDemoLocation();
      } else {
        await initDemoLocation();
      }

      final loc = _location.valueOrNull;
      if (loc == null) throw StateError('Demo location is not set.');

      final results = await _repo.ask(
        userText: userText,
        visitContext: visitContext,
        userProfile: p,
        locationName: loc.ntaName,
        userLat: loc.lat,
        userLng: loc.lng,
        requestIdOverride: requestId,
      );

      if (_activeRequestId != requestId) return;
      final pois = results.map((dto) => Poi.fromDto(dto)).toList();
      _state.add(SearchSuccess(requestId, pois));
    } catch (e) {
      if (_activeRequestId != requestId) return;
      _state.add(SearchError(requestId, e.toString()));
    }
  }

  void dispose() {
    _state.close();
    _location.close();
  }
}
