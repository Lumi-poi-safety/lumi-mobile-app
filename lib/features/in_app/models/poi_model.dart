import 'package:lumi/features/in_app/explore/models/results_dto.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';

class Poi {
  final String id;
  final String name;
  final String category;
  final SafetyTag tag;
  final double lat;
  final double lng;
  final String safetyReason;
  final String relevanceReason;

  const Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.tag,
    required this.lat,
    required this.lng,
    required this.safetyReason,
    required this.relevanceReason,
  });

  factory Poi.fromDto(PoiWsResult dto) {
    return Poi(
      id: _buildId(dto),
      name: dto.name,
      category: dto.category,
      tag: _mapSafetyLevel(dto.safetyLevel),
      lat: dto.lat,
      lng: dto.lng,
      safetyReason: dto.safetyReason,
      relevanceReason: dto.relevanceReason,
    );
  }

  static String _buildId(PoiWsResult dto) {
    final lat = dto.lat.toStringAsFixed(6);
    final lng = dto.lng.toStringAsFixed(6);
    return '${dto.name}_$lat\_$lng';
  }

  static SafetyTag _mapSafetyLevel(String level) {
    switch (level.toLowerCase()) {
      case 'green':
        return SafetyTag.generallySafe;
      case 'yellow':
        return SafetyTag.beCautious;
      case 'red':
        return SafetyTag.caution;
      case 'unknown':
      default:
        return SafetyTag.noData;
    }
  }
}
