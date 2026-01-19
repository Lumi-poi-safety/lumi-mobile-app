import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lumi/features/in_app/explore/explore_screen/widgets/marker_icons.dart';
import 'package:lumi/features/in_app/explore/home_search_screen.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';
import 'package:lumi/features/in_app/poi_details/poi_details_screen/poi_details_screen.dart';
import 'package:lumi/features/in_app/widgets/poi_details.dart';

class MapResultsScreen extends StatefulWidget {
  const MapResultsScreen({super.key});

  @override
  State<MapResultsScreen> createState() => _MapResultsScreenState();
}

class _MapResultsScreenState extends State<MapResultsScreen> {
  late MapResultsArgs args;
  GoogleMapController? _map;

  late final MarkerIcons _icons;
  final ValueNotifier<bool> _iconsReady = ValueNotifier<bool>(false);

  // Default center (NYC - Midtown Manhattan)
  static const _fallbackCenter = LatLng(40.7580, -73.9855);
  LatLng _center = _fallbackCenter;

  // TODO: replace with real ranked results based on args.query + args.context
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as MapResultsArgs;

    // _pins = const [
    //   _PoiPin(
    //     Poi(
    //       id: "nyc_1",
    //       name: "Breeze Café",
    //       category: "Cafe",
    //       tag: SafetyTag.generallySafe,
    //     ),
    //     LatLng(40.7587, -73.9851),
    //   ),
    //   _PoiPin(
    //     Poi(
    //       id: "nyc_2",
    //       name: "Café Nova",
    //       category: "Cafe",
    //       tag: SafetyTag.beCautious,
    //     ),
    //     LatLng(40.7616, -73.9827),
    //   ),
    //   _PoiPin(
    //     Poi(
    //       id: "nyc_3",
    //       name: "Dawn Coffee",
    //       category: "Cafe",
    //       tag: SafetyTag.caution,
    //     ),
    //     LatLng(40.7527, -73.9772),
    //   ),
    // ];
  }

  // Set<Marker> get _markers => _pins.map((p) {
  //   return Marker(
  //     markerId: MarkerId(p.poi.id),
  //     position: p.latLng,
  //     onTap: () => _openPoi(p.poi),
  //   );
  // }).toSet();

  // Future<void> _openPoi(Poi poi) async {
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
  //         Navigator.of(context).pop();
  //         await showModalBottomSheet<void>(
  //           context: context,
  //           isScrollControlled: true,
  //           useSafeArea: true,
  //           backgroundColor: Colors.white,
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //           ),
  //           builder: (_) =>
  //               PoiDetailsSheet(poi: poi, initialContext: args.context),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Lumi's Results")),
      body: Stack(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _iconsReady,
            builder: (BuildContext context, bool isReady, Widget? child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 13.5,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: _markers,
                onMapCreated: (c) => _map = c,
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        args.query,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _contextLabel(args.context),
                        style: t.bodyMedium?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _contextLabel(VisitContext ctx) {
    final w = switch (ctx.withWhom) {
      VisitWith.justMe => "Just me",
      VisitWith.friends => "Friends",
      VisitWith.date => "Date",
      VisitWith.family => "Family",
      null => "No visit context",
    };
    final c = switch (ctx.caution) {
      CautionLevel.relaxed => "Relaxed",
      CautionLevel.balanced => "Balanced",
      CautionLevel.cautious => "Very cautious",
      null => "—",
    };
    return "$w · $c";
  }
}

class _PoiPin {
  final Poi poi;
  final LatLng latLng;
  const _PoiPin({required this.poi, required this.latLng});
}
