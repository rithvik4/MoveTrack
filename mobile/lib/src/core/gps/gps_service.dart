import 'gps_service_stub.dart'
    if (dart.library.html) 'gps_service_web.dart';

class GpsReading {
  const GpsReading({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

abstract class GpsService {
  Future<GpsReading?> getCurrentLocation();
}

GpsService createGpsService() => createGpsServiceImpl();