import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:rxdart/rxdart.dart';

class SavedPlacesBloc {
  final BehaviorSubject<List<Poi>> _saved = BehaviorSubject.seeded(const []);

  Stream<List<Poi>> get saved$ => _saved.stream;
  List<Poi> get saved => _saved.value;

  void add(Poi poi) {
    if (_saved.value.any((p) => p.id == poi.id)) return;
    _saved.add([..._saved.value, poi]);
  }

  void remove(String poiId) {
    _saved.add(_saved.value.where((p) => p.id != poiId).toList());
  }

  bool isSaved(String poiId) {
    return _saved.value.any((p) => p.id == poiId);
  }

  void dispose() {
    _saved.close();
  }
}
