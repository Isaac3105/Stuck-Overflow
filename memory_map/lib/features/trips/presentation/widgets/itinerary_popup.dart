import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/geography.dart';
import '../../domain/trip.dart';

class ItineraryPopup extends ConsumerStatefulWidget {
  const ItineraryPopup({super.key, required this.trip});
  final Trip trip;

  @override
  ConsumerState<ItineraryPopup> createState() => _ItineraryPopupState();
}

class _ItineraryPopupState extends ConsumerState<ItineraryPopup> {
  final ScrollController _scrollController = ScrollController();
  bool _showTopArrow = false;
  bool _showBottomArrow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrows);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateArrows());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrows() {
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    bool showTop = currentScroll > 5;
    bool showBottom = maxScroll > 0 && currentScroll < maxScroll - 5;
    
    if (showTop != _showTopArrow || showBottom != _showBottomArrow) {
      if (mounted) {
        setState(() {
          _showTopArrow = showTop;
          _showBottomArrow = showBottom;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Grouping logic
    final grouped = <String, List<String>>{};
    for (final countryName in widget.trip.countries) {
      final entry = resolveGeography(countryName);
      if (entry == null) continue;
      final citiesInThisCountry = widget.trip.cities.where((city) => entry.districts.contains(city)).toList();
      grouped[entry.name] = citiesInThisCountry;
    }

    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: scheme.surfaceContainerHigh,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.4,
        ),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: _showTopArrow ? 1.0 : 0.0,
                child: Icon(Icons.keyboard_arrow_up_rounded, size: 28, color: scheme.onSurface),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: grouped.entries.map((group) {
                      final country = group.key;
                      final cities = group.value;
                      final countryEntry = resolveGeography(country);
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (countryEntry != null) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Flag.fromString(
                                      countryEntry.code,
                                      width: 24,
                                      height: 16,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: Text(
                                    country,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (cities.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 36),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: cities.map((city) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: Text(
                                      '• $city',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  )).toList(),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            const Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Opacity(
                opacity: _showBottomArrow ? 1.0 : 0.0,
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 28, color: scheme.onSurface),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
          ),
        ),
      ],
    );
  }
}

Future<void> showItineraryPopup(BuildContext context, Trip trip) {
  return showDialog(
    context: context,
    builder: (context) => ItineraryPopup(trip: trip),
  );
}
