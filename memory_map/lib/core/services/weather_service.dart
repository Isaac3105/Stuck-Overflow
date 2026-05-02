import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperatureC,
    required this.code,
    required this.description,
  });
  final double temperatureC;
  final int code;
  final String description;

  String get emoji => _emojiForCode(code);
}

String _emojiForCode(int code) {
  if (code == 0) return '☀️';
  if (code <= 3) return '⛅';
  if (code <= 48) return '🌫️';
  if (code <= 67) return '🌦️';
  if (code <= 77) return '❄️';
  if (code <= 82) return '🌧️';
  if (code <= 86) return '🌨️';
  if (code <= 99) return '⛈️';
  return '🌡️';
}

String _descriptionForCode(int code) {
  if (code == 0) return 'Céu limpo';
  if (code <= 3) return 'Pouco nublado';
  if (code <= 48) return 'Nevoeiro';
  if (code <= 57) return 'Chuvisco';
  if (code <= 67) return 'Chuva';
  if (code <= 77) return 'Neve';
  if (code <= 82) return 'Aguaceiros';
  if (code <= 86) return 'Aguaceiros de neve';
  return 'Trovoada';
}

class WeatherService {
  WeatherService(this._dio);
  final Dio _dio;

  /// Open-Meteo: free, no key. https://open-meteo.com/
  Future<WeatherSnapshot?> fetch({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current': 'temperature_2m,weather_code',
        },
      );
      final data = r.data;
      if (data == null) return null;
      final current = data['current'] as Map<String, dynamic>?;
      if (current == null) return null;
      final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 0.0;
      final code = (current['weather_code'] as num?)?.toInt() ?? 0;
      return WeatherSnapshot(
        temperatureC: temp,
        code: code,
        description: _descriptionForCode(code),
      );
    } catch (_) {
      return null;
    }
  }

  Future<WeatherSnapshot?> fetchHistorical({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) async {
    try {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final r = await _dio.get<Map<String, dynamic>>(
        'https://archive-api.open-meteo.com/v1/archive',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'start_date': dateStr,
          'end_date': dateStr,
          'daily': 'weather_code,temperature_2m_max',
          'timezone': 'auto',
        },
      );
      final data = r.data;
      if (data == null) return null;
      final daily = data['daily'] as Map<String, dynamic>?;
      if (daily == null) return null;
      
      final temps = daily['temperature_2m_max'] as List?;
      final codes = daily['weather_code'] as List?;
      
      final temp = (temps != null && temps.isNotEmpty) ? (temps.first as num).toDouble() : 0.0;
      final code = (codes != null && codes.isNotEmpty) ? (codes.first as num).toInt() : 0;
      
      return WeatherSnapshot(
        temperatureC: temp,
        code: code,
        description: _descriptionForCode(code),
      );
    } catch (_) {
      return null;
    }
  }
}

final dioProvider = Provider<Dio>((_) {
  final d = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  return d;
});

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(ref.watch(dioProvider));
});

class _Coords {
  const _Coords(this.lat, this.lng);
  final double lat;
  final double lng;
}

/// Default coordinates for the listed countries; used when device location
/// is unavailable. Picked the capital city for each.
const _capitalCoords = <String, _Coords>{
  'PT': _Coords(38.7167, -9.1333),
  'ES': _Coords(40.4167, -3.7033),
  'FR': _Coords(48.8566, 2.3522),
  'IT': _Coords(41.9028, 12.4964),
  'DE': _Coords(52.5200, 13.4050),
  'GB': _Coords(51.5074, -0.1278),
  'IE': _Coords(53.3498, -6.2603),
  'NL': _Coords(52.3676, 4.9041),
  'BE': _Coords(50.8503, 4.3517),
  'CH': _Coords(46.9480, 7.4474),
  'AT': _Coords(48.2082, 16.3738),
  'GR': _Coords(37.9838, 23.7275),
  'SE': _Coords(59.3293, 18.0686),
  'NO': _Coords(59.9139, 10.7522),
  'DK': _Coords(55.6761, 12.5683),
  'FI': _Coords(60.1699, 24.9384),
  'IS': _Coords(64.1466, -21.9426),
  'PL': _Coords(52.2297, 21.0122),
  'CZ': _Coords(50.0755, 14.4378),
  'HU': _Coords(47.4979, 19.0402),
  'HR': _Coords(45.8150, 15.9819),
  'RO': _Coords(44.4268, 26.1025),
  'TR': _Coords(41.0082, 28.9784),
  'US': _Coords(38.9072, -77.0369),
  'CA': _Coords(45.4215, -75.6972),
  'MX': _Coords(19.4326, -99.1332),
  'BR': _Coords(-15.7975, -47.8919),
  'AR': _Coords(-34.6037, -58.3816),
  'CL': _Coords(-33.4489, -70.6693),
  'PE': _Coords(-12.0464, -77.0428),
  'CO': _Coords(4.7110, -74.0721),
  'JP': _Coords(35.6762, 139.6503),
  'KR': _Coords(37.5665, 126.9780),
  'CN': _Coords(39.9042, 116.4074),
  'IN': _Coords(28.6139, 77.2090),
  'TH': _Coords(13.7563, 100.5018),
  'VN': _Coords(21.0285, 105.8542),
  'ID': _Coords(-6.2088, 106.8456),
  'PH': _Coords(14.5995, 120.9842),
  'AU': _Coords(-35.2809, 149.1300),
  'NZ': _Coords(-41.2924, 174.7787),
  'AE': _Coords(24.4539, 54.3773),
  'EG': _Coords(30.0444, 31.2357),
  'MA': _Coords(34.0209, -6.8416),
  'ZA': _Coords(-25.7479, 28.2293),
  'CV': _Coords(14.9215, -23.5087),
  'AO': _Coords(-8.8390, 13.2894),
  'MZ': _Coords(-25.9655, 32.5832),
};

/// Resolves a representative coordinate from a list of country codes.
({double lat, double lng})? coordsForCountries(List<String> countries) {
  for (final c in countries) {
    final m = _capitalCoords[c];
    if (m != null) return (lat: m.lat, lng: m.lng);
  }
  return null;
}
