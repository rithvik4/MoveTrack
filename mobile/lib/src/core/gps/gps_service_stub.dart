import 'gps_service.dart';

class _StubGpsService implements GpsService {
  @override
  Future<GpsReading?> getCurrentLocation() async {
    return null;
  }
}

GpsService createGpsServiceImpl() => _StubGpsService();