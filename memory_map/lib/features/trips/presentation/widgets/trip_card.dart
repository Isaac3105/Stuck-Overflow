import 'dart:io';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/trip.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
    this.coverImagePath,
  });

  final Trip trip;
  final VoidCallback onTap;
  final String? coverImagePath;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM', 'pt_PT');
    final period = '${df.format(trip.startDate)} – ${df.format(trip.endDate)}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: _CardCover(
                trip: trip,
                coverImagePath: coverImagePath,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    period,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardCover extends StatelessWidget {
  const _CardCover({required this.trip, this.coverImagePath});
  final Trip trip;
  final String? coverImagePath;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (coverImagePath != null)
          Image.file(
            File(coverImagePath!),
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => _gradient(scheme),
          )
        else
          _gradient(scheme),
        Positioned(
          left: 12,
          top: 12,
          child: Wrap(
            spacing: 4,
            children: trip.countries
                .take(4)
                .map(
                  (c) => ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: SizedBox(
                      width: 24,
                      height: 16,
                      child: Flag.fromString(c, fit: BoxFit.cover),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _gradient(ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
        ),
      ),
    );
  }
}
