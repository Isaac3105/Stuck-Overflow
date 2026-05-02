import 'dart:convert';
import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// One country polygon (exterior + optional holes), with a precomputed bbox.
class CountryShape {
  CountryShape({
    required this.exterior,
    required this.holes,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    this.isoA2,
  });

  final List<LatLng> exterior;
  final List<List<LatLng>> holes;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;

  /// ISO 3166-1 alpha-2 when present and reliable in the source data.
  final String? isoA2;

  bool intersectsViewport({
    required double centerLat,
    required double centerLng,
    required double halfLat,
    required double halfLng,
  }) {
    final lat0 = centerLat - halfLat;
    final lat1 = centerLat + halfLat;
    final lng0 = centerLng - halfLng;
    final lng1 = centerLng + halfLng;
    if (maxLat < lat0 || minLat > lat1) return false;
    if (maxLng < lng0 || minLng > lng1) return false;
    return true;
  }

  /// Axis-aligned bbox containment (good enough for camera / overseas splits).
  /// [pad] expands the box by [pad] degrees on each side (handles numeric edge cases).
  bool bboxContains(LatLng p, {double pad = 0}) =>
      p.latitude >= minLat - pad &&
      p.latitude <= maxLat + pad &&
      p.longitude >= minLng - pad &&
      p.longitude <= maxLng + pad;
}

List<CountryShape> parseCountryShapesFromGeoJson(String raw) {
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  final features = decoded['features'] as List<dynamic>? ?? const [];
  final out = <CountryShape>[];

  for (final f in features) {
    if (f is! Map<String, dynamic>) continue;
    final geom = f['geometry'];
    if (geom is! Map<String, dynamic>) continue;
    final type = geom['type'] as String?;
    final coords = geom['coordinates'];
    if (type == null || coords == null) continue;
    final iso = _readIsoA2(f);

    switch (type) {
      case 'Polygon':
        _addPolygon(out, coords as List<dynamic>, iso);
        break;
      case 'MultiPolygon':
        for (final poly in coords as List<dynamic>) {
          _addPolygon(out, poly as List<dynamic>, iso);
        }
        break;
      default:
        break;
    }
  }
  return out;
}

/// Natural Earth often uses `ISO_A2: "-99"` for France, Kosovo, etc.; use
/// [WB_A2] (World Bank style alpha-2) when the primary field is not usable.
String? _readIsoA2(Map<String, dynamic> feature) {
  final props = feature['properties'];
  if (props is! Map<String, dynamic>) return null;

  String? pickAlpha2(String key) {
    final raw = props[key];
    if (raw is! String) return null;
    final u = raw.trim().toUpperCase();
    if (u.length != 2) return null;
    if (u.startsWith('-')) return null;
    return u;
  }

  return pickAlpha2('ISO_A2') ?? pickAlpha2('WB_A2');
}

void _addPolygon(
  List<CountryShape> out,
  List<dynamic> ringsJson,
  String? isoA2,
) {
  if (ringsJson.isEmpty) return;
  final exterior = _ringToLatLng(ringsJson[0] as List<dynamic>);
  if (exterior.length < 3) return;

  final holes = <List<LatLng>>[];
  for (var i = 1; i < ringsJson.length; i++) {
    final h = _ringToLatLng(ringsJson[i] as List<dynamic>);
    if (h.length >= 3) holes.add(h);
  }

  var minLat = exterior.first.latitude;
  var maxLat = exterior.first.latitude;
  var minLng = exterior.first.longitude;
  var maxLng = exterior.first.longitude;
  for (final p in exterior) {
    minLat = math.min(minLat, p.latitude);
    maxLat = math.max(maxLat, p.latitude);
    minLng = math.min(minLng, p.longitude);
    maxLng = math.max(maxLng, p.longitude);
  }

  out.add(CountryShape(
    exterior: exterior,
    holes: holes,
    minLat: minLat,
    maxLat: maxLat,
    minLng: minLng,
    maxLng: maxLng,
    isoA2: isoA2,
  ));
}

List<LatLng> _ringToLatLng(List<dynamic> ring) {
  final pts = <LatLng>[];
  for (final pair in ring) {
    if (pair is! List || pair.length < 2) continue;
    final lng = (pair[0] as num).toDouble();
    final lat = (pair[1] as num).toDouble();
    pts.add(LatLng(lat, lng));
  }
  return pts;
}

/// Rough half-span in degrees for culling at a given zoom / latitude.
({double halfLat, double halfLng}) viewportHalfExtents({
  required double zoom,
  required double centerLat,
}) {
  final z = zoom.clamp(3.0, 18.0);
  final zi = z.floor().clamp(3, 18);
  final lngBase = 128 / (1 << zi);
  final cosLat =
      math.cos(centerLat * math.pi / 180).abs().clamp(0.2, 1.0);
  final halfLng = (lngBase / cosLat).clamp(0.4, 70.0);
  final halfLat = (halfLng * 0.65).clamp(0.35, 85.0);
  return (halfLat: halfLat, halfLng: halfLng);
}
