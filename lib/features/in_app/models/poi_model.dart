import 'package:lumi/features/in_app/models/safety_tag.dart';

class Poi {
  final String id;
  final String name;
  final String category;
  final SafetyTag tag;

  const Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.tag,
  });
}
