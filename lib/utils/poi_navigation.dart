import 'package:url_launcher/url_launcher.dart';

class PoiNavigation {
  /// Tries Google Maps app first, then falls back to browser maps URL.
  static Future<void> openDirections({
    required double lat,
    required double lng,
    String? name,
  }) async {
    final googleApp = Uri.parse('comgooglemaps://?daddr=$lat,$lng&directionsmode=walking');

    // Universal web fallback
    final googleWeb = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=walking',
    );

    final appleMaps = Uri.parse('http://maps.apple.com/?daddr=$lat,$lng&dirflg=w');

    if (await canLaunchUrl(googleApp)) {
      await launchUrl(googleApp, mode: LaunchMode.externalApplication);
      return;
    }

    if (await canLaunchUrl(appleMaps)) {
      await launchUrl(appleMaps, mode: LaunchMode.externalApplication);
      return;
    }

    await launchUrl(googleWeb, mode: LaunchMode.externalApplication);
  }
}
