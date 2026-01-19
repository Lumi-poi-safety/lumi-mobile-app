import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lumi/features/in_app/models/safety_tag.dart';

class MarkerIcons {
  final String safePath;
  final String cautionPath;
  final String dangerPath;
  final String noDataPath;
  ValueNotifier<bool> isLoaded;

  MarkerIcons({
    required this.safePath,
    required this.cautionPath,
    required this.dangerPath,
    required this.noDataPath,
    required this.isLoaded,
  }) {
    preload();
  }

  BitmapDescriptor? _safe;
  BitmapDescriptor? _caution;
  BitmapDescriptor? _danger;
  BitmapDescriptor? _noData;

  Future<void> preload({int targetWidthPx = 55}) async {
    log("before loading marker icons to BitmapDescriptors");
    _safe = await _fromAsset(safePath, targetWidthPx);
    _caution = await _fromAsset(cautionPath, targetWidthPx);
    _danger = await _fromAsset(dangerPath, targetWidthPx);
    _noData = await _fromAsset(noDataPath, targetWidthPx);
    isLoaded.value = true;
    log(
      "after loading marker icons to BitmapDescriptors: $_safe, $_caution, $_danger, $_noData",
    );
  }

  BitmapDescriptor forSafety(SafetyMarkerType type) {
    switch (type) {
      case SafetyMarkerType.safe:
        return _safe ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case SafetyMarkerType.caution:
        return _caution ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case SafetyMarkerType.danger:
        return _danger ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case SafetyMarkerType.noData:
        return _noData ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
  }

  static Future<BitmapDescriptor> _fromAsset(
    String path,
    int targetWidthPx,
  ) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: targetWidthPx,
    );
    final frame = await codec.getNextFrame();
    final bytes = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }
}

enum SafetyMarkerType { safe, caution, danger, noData }

SafetyMarkerType toMarkerType(SafetyTag tag) {
  switch (tag) {
    case SafetyTag.generallySafe:
      return SafetyMarkerType.safe;
    case SafetyTag.beCautious:
      return SafetyMarkerType.caution;
    case SafetyTag.caution:
      return SafetyMarkerType.danger;
    case SafetyTag.noData:
      return SafetyMarkerType.noData;
  }
}
