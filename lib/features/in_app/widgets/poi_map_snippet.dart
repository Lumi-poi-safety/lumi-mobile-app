import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PoiMapSnippet extends StatelessWidget {
  final double lat;
  final double lng;
  final String? title;

  final VoidCallback? onOpenFullMap;

  const PoiMapSnippet({
    super.key,
    required this.lat,
    required this.lng,
    this.title,
    this.onOpenFullMap,
  });

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(lat, lng);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: pos, zoom: 15.5),
                  markers: {
                    Marker(
                      markerId: const MarkerId('poi'),
                      position: pos,
                      infoWindow: title == null ? InfoWindow.noText : InfoWindow(title: title),
                    ),
                  },

                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,

                  liteModeEnabled: true,
                ),

                if (onOpenFullMap != null)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(onTap: onOpenFullMap),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
