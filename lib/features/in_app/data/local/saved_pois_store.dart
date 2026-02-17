import 'dart:convert';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPoisStore {
  static const _kSaved = 'saved.pois.v1';

  Future<List<Poi>> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_kSaved) ?? const [];
    return raw.map((s) => _fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }

  Future<void> save(Poi poi) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_kSaved) ?? <String>[];

    // de-dup by id
    final existing = list
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .map((m) => _fromJson(m))
        .toList();

    if (existing.any((p) => p.id == poi.id)) return;

    list.add(jsonEncode(_toJson(poi)));
    await sp.setStringList(_kSaved, list);
  }

  Future<void> remove(String id) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_kSaved) ?? <String>[];

    final filtered = list.where((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return (m['id'] as String) != id;
    }).toList();

    await sp.setStringList(_kSaved, filtered);
  }

  Future<bool> isSaved(String id) async {
    final items = await load();
    return items.any((p) => p.id == id);
  }

  Future<bool> toggle(Poi poi) async {
    final saved = await load();
    final exists = saved.any((p) => p.id == poi.id);
    if (exists) {
      await remove(poi.id);
      return false;
    } else {
      await save(poi);
      return true;
    }
  }

  Map<String, dynamic> _toJson(Poi p) => {
    'id': p.id,
    'name': p.name,
    'category': p.category,
    'tag': p.tag.name,
    'lat': p.lat,
    'lng': p.lng,
    'safetyReason': p.safetyReason,
    'relevanceReason': p.relevanceReason,
  };

  Poi _fromJson(Map<String, dynamic> m) => Poi(
    id: m['id'] as String,
    name: m['name'] as String,
    category: m['category'] as String,
    tag: SafetyTag.values.firstWhere((e) => e.name == (m['tag'] as String)),
    lat: m['lat'] as double,
    lng: m['lng'] as double,
    safetyReason: m['safetyReason'] as String? ?? '',
    relevanceReason: m['relevanceReason'] as String? ?? '',
  );
}
