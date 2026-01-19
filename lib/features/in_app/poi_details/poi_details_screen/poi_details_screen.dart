import 'package:flutter/material.dart';
import 'package:lumi/features/in_app/data/local/saved_pois_store.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class PoiPreviewSheet extends StatefulWidget {
  final Poi poi;
  final VoidCallback onViewDetails;

  const PoiPreviewSheet({
    super.key,
    required this.poi,
    required this.onViewDetails,
  });

  @override
  State<PoiPreviewSheet> createState() => _PoiPreviewSheetState();
}

class _PoiPreviewSheetState extends State<PoiPreviewSheet> {
  final _store = SavedPoisStore();
  bool _saved = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final v = await _store.isSaved(widget.poi.id);
    if (!mounted) return;
    setState(() {
      _saved = v;
      _loading = false;
    });
  }

  Future<void> _toggleSaved() async {
    setState(() => _loading = true);
    final nowSaved = await _store.toggle(widget.poi);
    if (!mounted) return;
    setState(() {
      _saved = nowSaved;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: Text(widget.poi.name, style: t.titleLarge)),
                Image.asset(widget.poi.tag.marker, width: 50, height: 50),
                Spacer(),
                IconButton(
                  onPressed: _loading ? null : _toggleSaved,
                  icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_outline),
                  tooltip: _saved ? "Saved" : "Save",
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              "${widget.poi.category} · ${widget.poi.tag.label}",
              style: t.bodyMedium?.copyWith(color: Colors.black54),
            ),

            const SizedBox(height: 12),
            Text(
              "Based on recent activity nearby",
              style: t.bodyMedium?.copyWith(color: Colors.black54),
            ),

            const SizedBox(height: 16),
            LumiPrimaryButton(
              onPressed: widget.onViewDetails,
              label: "View details",
            ),
          ],
        ),
      ),
    );
  }
}
