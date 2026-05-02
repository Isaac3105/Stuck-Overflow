import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'country_shapes_parser.dart';

final countryShapesProvider = FutureProvider<List<CountryShape>>((ref) async {
  const asset = 'assets/geo/ne_110m_admin_0_countries.geojson';
  final raw = await rootBundle.loadString(asset);
  return parseCountryShapesFromGeoJson(raw);
});
