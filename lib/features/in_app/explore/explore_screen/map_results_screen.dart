import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lumi/di/di.dart';
import 'package:lumi/features/in_app/explore/bloc/search_state.dart';
import 'package:lumi/features/in_app/explore/explore_screen/widgets/marker_icons.dart';
import 'package:lumi/features/in_app/explore/explore_screen/home_search_screen.dart';
import 'package:lumi/features/in_app/explore/models/demo_nta_location.dart';
import 'package:lumi/features/in_app/models/poi_model.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';
import 'package:lumi/features/in_app/poi_details/poi_details_screen/poi_details_screen.dart';
import 'package:lumi/features/in_app/widgets/poi_details.dart';
import 'package:lumi/widgets/lumi_loading.dart';

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

  static const _fallbackCenter = LatLng(40.7580, -73.9855);

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
          Navigator.of(context).pop();
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
  }

  Future<void> _openPoi(Poi poi) async {
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
          Navigator.of(context).pop();
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Lumi's Results")),
      body: StreamBuilder<SearchState>(
        stream: searchBloc.state$,
        builder: (context, snap) {
          final s = snap.data ?? const SearchIdle();

          final markers = switch (s) {
            SearchSuccess(:final results) => results.map((poi) {
              final icon = _iconsReady.value
                  ? _icons.forSafety(toMarkerType(poi.tag))
                  : BitmapDescriptor.defaultMarker;

              return Marker(
                markerId: MarkerId(poi.name),
                position: LatLng(poi.lat, poi.lng),
                icon: icon,
                onTap: () => _openPoi(poi),
              );
            }).toSet(),
            _ => <Marker>{},
          };

          return StreamBuilder<DemoNtaLocation?>(
            stream: searchBloc.location$,
            builder: (_, snap) {
              final loc = snap.data;
              print("miri: loc: $loc");
              final center = loc == null ? _fallbackCenter : LatLng(loc.lat, loc.lng);
              _map?.moveCamera(CameraUpdate.newLatLng(center));
              print("miri: center: $center");
              return Stack(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _iconsReady,
                    builder: (BuildContext context, bool isReady, Widget? child) {
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(target: center, zoom: 13.5),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        markers: markers,
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
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(args.query, style: const TextStyle(fontWeight: FontWeight.w600)),
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
                  if (s is SearchLoading) _Banner("Finding places…", isLoading: true),
                  if (s is SearchError) _Banner(s.message, isError: true),

                  if (s is SearchSuccess && s.results.isEmpty)
                    const _Banner("No matches found for this context."),
                ],
              );
            },
          );
        },
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

  _waitingAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: LumiLoading()),
    );
  }
}

class _PoiPin {
  final Poi poi;
  final LatLng latLng;
  const _PoiPin({required this.poi, required this.latLng});
}

class _Banner extends StatelessWidget {
  final String text;
  final bool isError;
  final bool isLoading;
  const _Banner(this.text, {this.isError = false, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: 30,
      right: 30,
      child: isLoading
          ? LumiLoading(size: 90, label: text)
          : Material(
              color: isError ? const Color(0xFFFFF0F0) : Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Text(text),
              ),
            ),
    );
  }
}
