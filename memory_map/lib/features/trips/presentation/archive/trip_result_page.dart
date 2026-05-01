import 'package:flutter/material.dart';

import 'trip_archive_page.dart';

/// Página detalhada da viagem (arquivo).
///
/// Mantém o fluxo do `my_trips_page.dart` (See details -> detalhes),
/// mas usa dados reais através do ecrã já existente do arquivo.
class TripResultPage extends StatelessWidget {
  const TripResultPage({super.key, required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context) {
    return TripArchivePage(tripId: tripId);
  }
}

