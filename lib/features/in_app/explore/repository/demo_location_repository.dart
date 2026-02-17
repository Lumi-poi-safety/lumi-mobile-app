import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lumi/features/in_app/explore/models/demo_nta_location.dart';

class DemoLocationRepository {
  final Random _rng;
  List<DemoNtaLocation>? _cache;

  DemoLocationRepository({Random? rng}) : _rng = rng ?? Random();

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;

    final raw = await rootBundle.loadString(
      'lib/assets/demo_locations/nyc_lighting_with_demo_coords.csv',
    );

    final lines = const LineSplitter().convert(raw);
    if (lines.length < 2) {
      _cache = const [];
      return;
    }

    final header = _splitCsvLine(lines.first);
    final idxName = header.indexOf('ntaname');
    final idxLat = header.indexOf('demo_lat');
    final idxLng = header.indexOf('demo_lng');

    if (idxName < 0 || idxLat < 0 || idxLng < 0) {
      throw StateError('CSV missing required columns: ntaname, demo_lat, demo_lng');
    }

    final out = <DemoNtaLocation>[];
    for (final line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;
      final cols = _splitCsvLine(line);
      if (cols.length <= [idxName, idxLat, idxLng].reduce((a, b) => a > b ? a : b)) {
        continue;
      }

      final name = cols[idxName].trim();
      final lat = double.tryParse(cols[idxLat].trim());
      final lng = double.tryParse(cols[idxLng].trim());
      if (name.isEmpty || lat == null || lng == null) continue;

      out.add(DemoNtaLocation(ntaName: name, lat: lat, lng: lng));
    }

    _cache = out;
  }

  Future<DemoNtaLocation> pickRandom() async {
    await _ensureLoaded();
    final list = _cache ?? const [];
    if (list.isEmpty) throw StateError('No demo locations loaded from CSV.');
    return list[_rng.nextInt(list.length)];
  }

  Future<DemoNtaLocation?> pickRandomForNeighborhood(String ntaName) async {
    await _ensureLoaded();
    final list = (_cache ?? const []).where((e) => e.ntaName == ntaName).toList();
    if (list.isEmpty) return null;
    return list[_rng.nextInt(list.length)];
  }

  List<String> _splitCsvLine(String line) => line.split(',');
}
