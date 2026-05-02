import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'geo/country_shapes_parser.dart';
import 'geo/country_shapes_provider.dart';
import 'geo/trip_country_bounds.dart';

Color _cartoonMapBase(ColorScheme scheme) => Color.alphaBlend(
      scheme.primary.withValues(alpha: 0.08),
      scheme.surfaceContainerLow,
    );

/// Stylised map: theme colours + Natural Earth country outlines only (no raster tiles).
///
/// Trip countries share one fill; neighbours use a lighter fill and dashed
/// borders. Single-country trips frame polygons that contain (or sit near) the
/// marker so overseas territories do not shrink metropolitan France. Several
/// countries use the full union with extra padding so all stay visible.
class MemoryPreviewMap extends ConsumerWidget {
  const MemoryPreviewMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.fallbackZoom,
    required this.tripCountryNames,
  });

  final double latitude;
  final double longitude;
  final double fallbackZoom;

  /// Country names from the trip (same strings as in [Trip.countries]).
  final List<String> tripCountryNames;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final shapesAsync = ref.watch(countryShapesProvider);

    return shapesAsync.when(
      loading: () => ColoredBox(color: _cartoonMapBase(scheme)),
      error: (_, _) => ColoredBox(color: _cartoonMapBase(scheme)),
      data: (shapes) => _CartoonCountryMapBody(
        shapes: shapes,
        latitude: latitude,
        longitude: longitude,
        fallbackZoom: fallbackZoom,
        tripCountryNames: tripCountryNames,
        scheme: scheme,
      ),
    );
  }
}

class _CartoonCountryMapBody extends StatelessWidget {
  const _CartoonCountryMapBody({
    required this.shapes,
    required this.latitude,
    required this.longitude,
    required this.fallbackZoom,
    required this.tripCountryNames,
    required this.scheme,
  });

  final List<CountryShape> shapes;
  final double latitude;
  final double longitude;
  final double fallbackZoom;
  final List<String> tripCountryNames;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final center = LatLng(latitude, longitude);
    final codes = isoCodesFromTripCountryNames(tripCountryNames);
    final fitBounds = resolveCameraFitBounds(
      codes: codes,
      tripCountryNames: tripCountryNames,
      shapes: shapes,
      center: center,
    );

    final tripFill = scheme.primaryContainer.withValues(alpha: 0.24);
    final tripBorder = scheme.outline.withValues(alpha: 0.88);
    final contextFill =
        scheme.surfaceContainerHighest.withValues(alpha: 0.42);
    final contextBorder = scheme.onSurface.withValues(alpha: 0.32);

    final tripPolygons = <Polygon<Object>>[];
    final contextPolygons = <Polygon<Object>>[];

    if (codes.isNotEmpty) {
      for (final s in shapesForIsoCodes(codes, shapes)) {
        tripPolygons.add(
          Polygon<Object>(
            points: s.exterior,
            holePointsList: s.holes.isEmpty ? null : s.holes,
            color: tripFill,
            borderStrokeWidth: 1.45,
            borderColor: tripBorder,
            pattern: const StrokePattern.solid(),
          ),
        );
      }

      if (fitBounds != null) {
        final contextWindow = expandBoundsAroundCenter(fitBounds, 1.24);
        for (final s in shapes) {
          final iso = s.isoA2?.toUpperCase();
          if (iso == null || iso.length != 2) continue;
          if (codes.contains(iso)) continue;
          if (!shapeBBoxIntersectsLatLngBounds(s, contextWindow)) continue;
          contextPolygons.add(
            Polygon<Object>(
              points: s.exterior,
              holePointsList: s.holes.isEmpty ? null : s.holes,
              color: contextFill,
              borderStrokeWidth: 1.15,
              borderColor: contextBorder,
              pattern: StrokePattern.dashed(
                segments: const [5, 4],
                patternFit: PatternFit.scaleUp,
              ),
            ),
          );
        }
      }
    }

    if (tripPolygons.isEmpty) {
      final extents =
          viewportHalfExtents(zoom: fallbackZoom, centerLat: latitude);
      var filtered = shapes
          .where(
            (s) => s.intersectsViewport(
              centerLat: latitude,
              centerLng: longitude,
              halfLat: extents.halfLat * 1.15,
              halfLng: extents.halfLng * 1.15,
            ),
          )
          .toList();
      if (filtered.isEmpty) filtered = shapes;
      for (final s in filtered) {
        tripPolygons.add(
          Polygon<Object>(
            points: s.exterior,
            holePointsList: s.holes.isEmpty ? null : s.holes,
            color: tripFill,
            borderStrokeWidth: 1.45,
            borderColor: tripBorder,
            pattern: const StrokePattern.solid(),
          ),
        );
      }
    }

    final MapOptions mapOptions;
    if (fitBounds != null) {
      mapOptions = MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: fitBounds,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          maxZoom: 18,
        ),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
        backgroundColor: Colors.transparent,
      );
    } else {
      mapOptions = MapOptions(
        initialCenter: center,
        initialZoom: fallbackZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
        backgroundColor: Colors.transparent,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: _cartoonMapBase(scheme)),
        FlutterMap(
          options: mapOptions,
          children: [
            PolygonLayer<Object>(polygons: contextPolygons),
            PolygonLayer<Object>(polygons: tripPolygons),
          ],
        ),
      ],
    );
  }
}
