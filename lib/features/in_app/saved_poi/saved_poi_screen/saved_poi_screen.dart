import 'package:flutter/material.dart';
import 'package:lumi/features/in_app/data/local/saved_pois_store.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';
import 'package:lumi/features/in_app/widgets/lumi_app_bar.dart';
import 'package:lumi/features/in_app/widgets/poi_details.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final _store = SavedPoisStore();
  List<Poi>? _saved;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _store.load();
    if (!mounted) return;
    setState(() => _saved = items);
  }

  Future<void> _remove(String id) async {
    await _store.remove(id);
    await _load();
  }

  Future<void> _openDetails(Poi poi) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PoiDetailsSheet(
        poi: poi,
        initialContext: const VisitContext(), // context optional for saved
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: lumiAppBar(
        "Saved Places",
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _saved == null
          ? const Center(child: CircularProgressIndicator())
          : _saved!.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                "No saved places yet.",
                style: t.bodyLarge?.copyWith(color: Colors.black54),
              ),
            )
          : ListView.separated(
              itemCount: _saved!.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final poi = _saved![i];
                return ListTile(
                  // leading: Image.asset(poi.tag.marker, width: 50, height: 50),
                  title: Text(
                    poi.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(poi.category),
                  onTap: () => _openDetails(poi),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _remove(poi.id),
                  ),
                );
              },
            ),
    );
  }
}
