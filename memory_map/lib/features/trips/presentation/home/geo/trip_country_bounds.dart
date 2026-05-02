import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/data/geography.dart';
import '../../../../../core/services/weather_service.dart';
import 'country_shapes_parser.dart';

/// Resolves trip planner country names / codes to ISO alpha-2 codes.
Set<String> isoCodesFromTripCountryNames(List<String> names) {
  final codes = <String>{};
  for (final n in names) {
    final entry = resolveGeography(n);
    if (entry != null) codes.add(entry.code.toUpperCase());
  }
  return codes;
}

List<CountryShape> shapesForIsoCodes(
  Set<String> codes,
  List<CountryShape> all,
) {
  return all.where((s) {
    final iso = s.isoA2?.toUpperCase();
    return iso != null && iso.length == 2 && codes.contains(iso);
  }).toList();
}

/// Raw edges (no padding) merged from [shapes].
({double south, double north, double west, double east})? rawBoundsMerged(
  Iterable<CountryShape> shapes,
) {
  var any = false;
  var south = 90.0;
  var north = -90.0;
  var west = 180.0;
  var east = -180.0;
  for (final s in shapes) {
    any = true;
    south = math.min(south, s.minLat);
    north = math.max(north, s.maxLat);
    west = math.min(west, s.minLng);
    east = math.max(east, s.maxLng);
  }
  if (!any) return null;
  return (south: south, north: north, west: west, east: east);
}

({double south, double north, double west, double east}) rawIncludingPoint(
  ({double south, double north, double west, double east}) r,
  LatLng p,
) {
  return (
    south: math.min(r.south, p.latitude),
    north: math.max(r.north, p.latitude),
    west: math.min(r.west, p.longitude),
    east: math.max(r.east, p.longitude),
  );
}

LatLngBounds? latLngBoundsWithPadding(
  ({double south, double north, double west, double east}) raw, {
  double padFraction = 0.09,
  double minPadDegrees = 0.2,
}) {
  final latSpan = (raw.north - raw.south).clamp(0.05, 170.0);
  final lngSpan = (raw.east - raw.west).clamp(0.05, 360.0);
  final padLat = latSpan * padFraction + minPadDegrees;
  final padLng = lngSpan * padFraction + minPadDegrees;
  return LatLngBounds(
    LatLng(raw.south - padLat, raw.west - padLng),
    LatLng(raw.north + padLat, raw.east + padLng),
  );
}

/// Bounding box covering all shapes whose [CountryShape.isoA2] is in [codes],
/// with padding so coastlines are not clipped.
LatLngBounds? mergedBoundsForIsoCodes(
  Set<String> codes,
  List<CountryShape> shapes,
) {
  if (codes.isEmpty) return null;
  final raw = rawBoundsMerged(shapesForIsoCodes(codes, shapes));
  if (raw == null) return null;
  return latLngBoundsWithPadding(raw);
}

/// Loose corridor around trip capitals so we can drop overseas polygons when
/// framing France + Spain (etc.).
({double south, double north, double west, double east})?
    rawCorridorAroundTripCapitals(List<String> tripCountryNames) {
  final caps = <({double lat, double lng})>[];
  for (final n in tripCountryNames) {
    final iso = resolveGeography(n)?.code;
    if (iso == null) continue;
    final c = capitalLatLngForIso(iso);
    if (c != null) caps.add(c);
  }
  if (caps.isEmpty) return null;

  var south = 90.0;
  var north = -90.0;
  var west = 180.0;
  var east = -180.0;
  for (final p in caps) {
    south = math.min(south, p.lat);
    north = math.max(north, p.lat);
    west = math.min(west, p.lng);
    east = math.max(east, p.lng);
  }

  final latSpan = (north - south).clamp(0.25, 180.0);
  final lngSpan = (east - west).clamp(0.25, 360.0);
  final padLat = math.max(latSpan * 0.68, 3.4);
  final padLng = math.max(lngSpan * 0.68, 4.2);

  return (
    south: south - padLat,
    north: north + padLat,
    west: west - padLng,
    east: east + padLng,
  );
}

bool shapeIntersectsRawBBox(
  CountryShape s,
  ({double south, double north, double west, double east}) r,
) =>
    !(s.maxLat < r.south ||
        s.minLat > r.north ||
        s.maxLng < r.west ||
        s.minLng > r.east);

/// Camera bounds for the preview map.
///
/// * **Several countries**: only trip polygons that intersect a **corridor
///   around the trip capitals** (avoids zooming to overseas territories), then
///   merge with [center]. Falls back to the full union if nothing matches.
/// * **One country**: polygons near [center] (bbox / neighbourhood), else full.
LatLngBounds? resolveCameraFitBounds({
  required Set<String> codes,
  required List<String> tripCountryNames,
  required List<CountryShape> shapes,
  required LatLng center,
}) {
  if (codes.isEmpty) return null;
  final tripShapes = shapesForIsoCodes(codes, shapes);
  final fullRaw = rawBoundsMerged(tripShapes);
  if (fullRaw == null) return null;

  if (codes.length > 1) {
    final corridor = rawCorridorAroundTripCapitals(tripCountryNames);
    var focusList = <CountryShape>[];
    if (corridor != null) {
      focusList = tripShapes
          .where((s) => shapeIntersectsRawBBox(s, corridor))
          .toList();
    }
    final regionalRaw = rawBoundsMerged(focusList);
    final rawBase = regionalRaw ?? fullRaw;
    final raw = rawIncludingPoint(rawBase, center);
    return latLngBoundsWithPadding(
      raw,
      padFraction: 0.095,
      minPadDegrees: 0.32,
    );
  }

  const geoSlop = 0.08;
  var focusList = tripShapes
      .where((s) => s.bboxContains(center, pad: geoSlop))
      .toList();

  if (focusList.isEmpty) {
    const nearHalf = 6.0;
    focusList = tripShapes
        .where(
          (s) => s.intersectsViewport(
            centerLat: center.latitude,
            centerLng: center.longitude,
            halfLat: nearHalf,
            halfLng: nearHalf,
          ),
        )
        .toList();
  }

  final mergedFocus = rawBoundsMerged(focusList);
  final rawForCamera = rawIncludingPoint(
    mergedFocus ?? fullRaw,
    center,
  );

  return latLngBoundsWithPadding(
    rawForCamera,
    padFraction: 0.065,
    minPadDegrees: 0.12,
  );
}

/// Grows [b] around its centre so nearby countries can be drawn as context.
LatLngBounds expandBoundsAroundCenter(LatLngBounds b, double factor) {
  final latC = (b.north + b.south) / 2;
  final lngC = (b.east + b.west) / 2;
  final hLat = (b.north - b.south) / 2 * factor;
  final hLng = (b.east - b.west) / 2 * factor;
  return LatLngBounds(
    LatLng(latC - hLat, lngC - hLng),
    LatLng(latC + hLat, lngC + hLng),
  );
}

bool shapeBBoxIntersectsLatLngBounds(CountryShape s, LatLngBounds b) =>
    !(s.maxLat < b.south ||
        s.minLat > b.north ||
        s.maxLng < b.west ||
        s.minLng > b.east);
