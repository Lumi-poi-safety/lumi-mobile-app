import 'package:flutter/material.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';
import 'package:lumi/features/in_app/widgets/poi_map_snippet.dart';
import 'package:lumi/style/age_buttons_style.dart';
import 'package:lumi/utils/poi_navigation.dart';
import 'package:lumi/utils/poi_share.dart';

class PoiDetailsSheet extends StatefulWidget {
  final Poi poi;

  const PoiDetailsSheet({super.key, required this.poi});

  @override
  State<PoiDetailsSheet> createState() => _PoiDetailsSheetState();
}

class _PoiDetailsSheetState extends State<PoiDetailsSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.70,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: Text(widget.poi.name, style: t.titleLarge)),
                Image.asset(widget.poi.tag.marker, width: 50, height: 50),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            Text(
              "${widget.poi.category} · ${widget.poi.tag.label}",
              style: t.bodyMedium?.copyWith(color: Colors.black54),
            ),

            const SizedBox(height: 16),
            Text(_summaryLine(widget.poi.tag), style: t.titleLarge),
            const SizedBox(height: 8),
            Text(
              _detailsParagraph(widget.poi.tag),
              style: t.bodyMedium?.copyWith(color: Colors.black54, height: 1.35),
            ),

            const SizedBox(height: 18),
            Text("Why Lumi thinks this", style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _Bullet(widget.poi.safetyReason),
            _Bullet(widget.poi.relevanceReason),

            const SizedBox(height: 18),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: PoiMapSnippet(lat: widget.poi.lat, lng: widget.poi.lng),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => PoiShare.sharePoi(context, widget.poi),
                    icon: const Icon(Icons.ios_share_outlined),
                    label: const Text("Share"),
                    style: LumiAgeButtonStyles.selected,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => PoiNavigation.openDirections(
                      lat: widget.poi.lat,
                      lng: widget.poi.lng,
                      name: widget.poi.name,
                    ),
                    icon: const Icon(Icons.navigation_outlined),
                    label: const Text("Navigate"),
                    style: LumiAgeButtonStyles.selected,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _summaryLine(SafetyTag tag) {
    switch (tag) {
      case SafetyTag.generallySafe:
        return "Calm area, good daytime spot";
      case SafetyTag.beCautious:
        return "Mixed signals, stay aware";
      case SafetyTag.caution:
        return "Higher activity nearby — be careful";
      case SafetyTag.noData:
        return "No recent data available";
    }
  }

  String _detailsParagraph(SafetyTag tag) {
    switch (tag) {
      case SafetyTag.generallySafe:
        return "Typically calm environment with low recent activity nearby. Still, stay aware-conditions can change.";
      case SafetyTag.beCautious:
        return "Some recent activity nearby. This place may be fine depending on time and context-choose accordingly.";
      case SafetyTag.caution:
        return "Recent activity suggests higher unpredictability nearby. Consider alternatives, especially during late hours.";
      case SafetyTag.noData:
        return "No recent data available. This place may be fine depending on time and context-choose accordingly.";
    }
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  "),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.black.withOpacity(0.75))),
          ),
        ],
      ),
    );
  }
}
