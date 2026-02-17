import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/widgets.dart';

class PoiShare {
  static Future<void> sharePoi(BuildContext context, Poi poi) async {
    final text = _buildText(poi);

    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;

    await SharePlus.instance.share(ShareParams(text: text, sharePositionOrigin: origin));
  }

  static String _buildText(Poi poi) {
    final safety = _safetyLine(poi);
    final reasons = _reasons(poi);

    return [
      'Lumi suggestion: ${poi.name}',
      if (poi.category.isNotEmpty) 'Category: ${poi.category}',
      if (safety != null) safety,
      if (reasons != null) reasons,
      'Location: ${poi.lat}, ${poi.lng}',
    ].whereType<String>().join('\n');
  }

  static String? _safetyLine(Poi poi) {
    switch (poi.tag) {
      case SafetyTag.generallySafe:
        return 'Safety: Generally safe';
      case SafetyTag.beCautious:
        return 'Safety: Mixed signals — be aware';
      case SafetyTag.caution:
        return 'Safety: Be cautious';
      case SafetyTag.noData:
        return 'Safety: Not enough data';
    }
  }

  static String? _reasons(Poi poi) {
    final safetyReason = poi.safetyReason.trim();
    final relevanceReason = poi.relevanceReason.trim();

    if (safetyReason.isEmpty && relevanceReason.isEmpty) return null;

    final parts = <String>[];
    if (relevanceReason.isNotEmpty) parts.add('Why it fits: $relevanceReason');
    if (safetyReason.isNotEmpty) parts.add('Safety note: $safetyReason');

    return parts.join('\n');
  }
}
