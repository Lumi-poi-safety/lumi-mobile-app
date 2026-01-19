// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   get Geolocator => null;

//   Future<Position?> getCurrentPosition() async {
//     final enabled = await Geolocator.isLocationServiceEnabled();
//     if (!enabled) return null;

//     var perm = await Geolocator.checkPermission();
//     if (perm == LocationPermission.denied) {
//       perm = await Geolocator.requestPermission();
//     }
//     if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
//       return null;
//     }

//     return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }
// }
