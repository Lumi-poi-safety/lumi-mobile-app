import 'package:flutter/material.dart';
import 'package:lumi/di/di.dart';
import 'package:lumi/features/in_app/data/local/saved_pois_store.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
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
      builder: (_) => PoiDetailsSheet(poi: poi),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: lumiAppBar("Saved Places"),
      body: StreamBuilder<List<Poi>>(
        stream: savedPlacesBloc.saved$,
        builder: (context, snapshot) {
          final places = snapshot.data ?? const [];

          if (places.isEmpty) {
            return _emptySavedState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: places.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final poi = places[i];
              return _savedPlaceTile(poi: poi);
            },
          );
        },
      ),
    );
  }

  Widget _emptySavedState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        "No saved places yet.",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54),
      ),
    );
  }

  Widget _savedPlaceTile({required Poi poi}) {
    return ListTile(
      title: Text(poi.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(poi.category),
      onTap: () => _openDetails(poi),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          _remove(poi.id);
          if (savedPlacesBloc.isSaved(poi.id)) {
            savedPlacesBloc.remove(poi.id);
          } else {
            savedPlacesBloc.add(poi);
          }
        },
      ),
    );
  }
}
