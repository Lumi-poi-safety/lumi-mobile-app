import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lumi/features/in_app/explore/explore_screen/widgets/marker_icons.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';
import 'package:lumi/features/in_app/widgets/poi_details.dart';
import 'package:lumi/features/in_app/explore/explore_screen/widgets/search_sheet.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';
import 'package:lumi/features/in_app/explore/explore_screen/widgets/visit_context_sheet.dart';
import 'package:lumi/features/in_app/poi_details/poi_details_screen/poi_details_screen.dart';

class ExploreMapScreen extends StatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  GoogleMapController? _map;

  late final MarkerIcons _icons;
  ValueNotifier<bool> _iconsReady = ValueNotifier<bool>(false);

  // Default center (NYC - Midtown Manhattan)
  static const _fallbackCenter = LatLng(40.7580, -73.9855);
  LatLng _center = _fallbackCenter;

  final List<_PoiPin> _demoPins = const [
    _PoiPin(
      poi: Poi(
        id: "nyc_1",
        name: "Breeze Café",
        category: "Cafe",
        tag: SafetyTag.noData,
      ),
      latLng: LatLng(40.7587, -73.9851), // Times Sq
    ),
    _PoiPin(
      poi: Poi(
        id: "nyc_2",
        name: "Café Espresso-holic",
        category: "Cafe",
        tag: SafetyTag.beCautious,
      ),
      latLng: LatLng(40.7616, -73.9827), // near Central Park S
    ),
    _PoiPin(
      poi: Poi(
        id: "nyc_3",
        name: "Dawn Coffee",
        category: "Cafe",
        tag: SafetyTag.caution,
      ),
      latLng: LatLng(40.7527, -73.9772), // Grand Central
    ),
    _PoiPin(
      poi: Poi(
        id: "nyc_4",
        name: "Luna Bistro",
        category: "Restaurant",
        tag: SafetyTag.generallySafe,
      ),
      latLng: LatLng(40.7309, -73.9973), // Washington Sq Park
    ),
  ];

  Set<Marker> get _markers {
    return _demoPins.map((pin) {
      final icon = _iconsReady.value
          ? _icons.forSafety(toMarkerType(pin.poi.tag))
          : BitmapDescriptor.defaultMarker;

      log(icon.toString());
      return Marker(
        markerId: MarkerId(pin.poi.id),
        position: pin.latLng,
        icon: icon,
        onTap: () => _openPoiFromMarker(pin.poi),
      );
    }).toSet();
  }

  Future<void> _openPoiFromMarker(Poi poi) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PoiPreviewSheet(
        poi: poi,
        onViewDetails: () async {
          Navigator.of(context).pop(); // close preview first

          // For now: open details with empty context.
          // Once VisitContextSheet is fixed, we’ll insert it here.
          // final visitContext = await showModalBottomSheet<VisitContext>(...);

          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) =>
                PoiDetailsSheet(poi: poi, initialContext: const VisitContext()),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _icons = MarkerIcons(
      safePath: SafetyTag.generallySafe.marker,
      cautionPath: SafetyTag.beCautious.marker,
      dangerPath: SafetyTag.caution.marker,
      noDataPath: SafetyTag.noData.marker,
      isLoaded: _iconsReady,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _iconsReady,
            builder: (BuildContext context, bool isReady, Widget? child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: _markers,
                onMapCreated: (c) => _map = c,
              );
            },
          ),

          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black.withOpacity(0.03),
          //     child: Center(
          //       child: Icon(
          //         Icons.map_outlined,
          //         size: 64,
          //         color: Colors.black.withOpacity(0.25),
          //       ),
          //     ),
          //   ),
          // ),

          // TOP SEARCH BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _SearchField(
                      onTap: () {
                        _openSearchFlow(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filters later.')),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.tune),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // // Example POI preview card placeholder (bottom)
          // Positioned(
          //   left: 16,
          //   right: 16,
          //   bottom: 16,
          //   child: _PoiPreviewCard(
          //     title: "Luna Bistro",
          //     subtitle: "Restaurant",
          //     onTap: () {
          //       // Later: open PoiDetailsScreen
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(content: Text('POI details screen next.')),
          //       );
          //     },
          //     accent: cs.primary,
          //   ),
          // ),
          // Positioned(
          //   right: 16,
          //   bottom: 0,
          //   child: FloatingActionButton.extended(
          //     onPressed: () {
          //       final poi = Poi(
          //         id: "demo",
          //         name: "Luna Bistro",
          //         category: "Restaurant",
          //         tag: SafetyTag.generallySafe,
          //       );
          //       _openPoiFromMarker(poi);
          //     },
          //     label: const Text("Tap marker"),
          //     icon: const Icon(Icons.place),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> _openSearchFlow(BuildContext context) async {
    // 1) Search sheet: returns selected POI
    final poi = await showModalBottomSheet<Poi>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const VisitContextSheet(
        initial: VisitContext(
          withWhom: VisitWith.justMe,
          caution: CautionLevel.cautious,
        ),
      ),
    );

    if (poi == null) return;

    // 2) Visit context sheet (ephemeral)
    final visitContext = await showModalBottomSheet<VisitContext>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const VisitContextSheet(initial: VisitContext()),
    );

    final ctx = visitContext ?? const VisitContext();

    // 3) POI details sheet (draggable)
    // Important: open AFTER previous sheet closes, so it stacks cleanly.
    // (showModalBottomSheet already waits for previous to close.)
    // ignore: use_build_context_synchronously
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PoiDetailsSheet(poi: poi, initialContext: ctx),
    );
  }

  // Future<void> _openPoiFromMarker(BuildContext context, Poi poi) async {
  //   await showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //     ),
  //     builder: (_) => PoiPreviewSheet(
  //       poi: poi,
  //       onViewDetails: () async {
  //         Navigator.of(context).pop(); // close preview first

  //         // Ask visit context (ephemeral)
  //         final visitContext = await showModalBottomSheet<VisitContext>(
  //           context: context,
  //           isScrollControlled: true,
  //           useSafeArea: true,
  //           backgroundColor: Colors.white,
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //           ),
  //           builder: (_) => const VisitContextSheet(initial: VisitContext()),
  //         );

  //         final ctx = visitContext ?? const VisitContext();

  //         // Open details draggable sheet
  //         // ignore: use_build_context_synchronously
  //         await showModalBottomSheet<void>(
  //           context: context,
  //           isScrollControlled: true,
  //           useSafeArea: true,
  //           backgroundColor: Colors.white,
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //           ),
  //           builder: (_) => PoiDetailsSheet(poi: poi, initialContext: ctx),
  //         );
  //       },
  //     ),
  //   );
  // }
}

class _SearchField extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchField({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black.withOpacity(0.55)),
              const SizedBox(width: 10),
              Text(
                "Search places or categories",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.55),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PoiPreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  const _PoiPreviewCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.place_outlined, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.black.withOpacity(0.55)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _PoiPin {
  final Poi poi;
  final LatLng latLng;
  const _PoiPin({required this.poi, required this.latLng});
}
