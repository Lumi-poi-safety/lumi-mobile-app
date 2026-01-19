import 'package:flutter/material.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import '../../../models/safety_tag.dart';

class SearchSheet extends StatefulWidget {
  const SearchSheet({super.key});

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  final _controller = TextEditingController();

  // Mock data for now
  final List<Poi> _all = const [
    Poi(
      id: "1",
      name: "Breeze Café",
      category: "Cafe",
      tag: SafetyTag.generallySafe,
    ),
    Poi(
      id: "2",
      name: "Café Nova",
      category: "Cafe",
      tag: SafetyTag.beCautious,
    ),
    Poi(id: "3", name: "Dawn Coffee", category: "Cafe", tag: SafetyTag.caution),
    Poi(
      id: "4",
      name: "Luna Bistro",
      category: "Restaurant",
      tag: SafetyTag.generallySafe,
    ),
  ];

  String _q = "";

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => setState(() => _q = _controller.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Poi> get _filtered {
    if (_q.isEmpty) return _all;
    return _all.where((p) {
      final hay = "${p.name} ${p.category}".toLowerCase();
      return hay.contains(_q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            // Grab handle
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
                Expanded(child: Text("Search POIs", style: t.titleLarge)),
                IconButton(
                  onPressed: () => Navigator.of(context).pop<Poi>(null),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search places or categories",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final poi = _filtered[i];
                  return ListTile(
                    title: Text(
                      poi.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(poi.category),
                    trailing: _SafetyChip(tag: poi.tag),
                    onTap: () => Navigator.of(context).pop<Poi>(poi),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyChip extends StatelessWidget {
  final SafetyTag tag;
  const _SafetyChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Color bg;
    switch (tag) {
      case SafetyTag.generallySafe:
        bg = cs.primary.withOpacity(0.12);
        break;
      case SafetyTag.beCautious:
        bg = Colors.orange.withOpacity(0.14);
        break;
      case SafetyTag.caution:
        bg = Colors.red.withOpacity(0.12);
        break;
      case SafetyTag.noData:
        bg = Colors.white.withOpacity(0.12);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag.label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
