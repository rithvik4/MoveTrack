import 'dart:async';
import 'dart:html' as html;

import 'gps_service.dart';

class _WebGpsService implements GpsService {
  @override
  Future<GpsReading?> getCurrentLocation() async {
    if (html.window.navigator.geolocation == null) {
      return null;
    }

    try {
      final html.Geoposition position =
          await html.window.navigator.geolocation.getCurrentPosition();
      return GpsReading(
        latitude: ((position.coords?.latitude ?? 0) as num).toDouble(),
        longitude: ((position.coords?.longitude ?? 0) as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}

GpsService createGpsServiceImpl() => _WebGpsService();