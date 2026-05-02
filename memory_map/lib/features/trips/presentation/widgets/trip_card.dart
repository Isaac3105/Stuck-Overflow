import 'dart:io';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/geography.dart';
import '../../domain/trip.dart';

/// [cover] — photo hero when [coverImagePath] is set; otherwise same text card
/// as archive-style (flags, dates, name, rating).
/// [plan] — text-only for planning (no rating, no image).
enum TripCardLayout { cover, plan }

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
    this.coverImagePath,
    this.layout = TripCardLayout.cover,
  });

  final Trip trip;
  final VoidCallback onTap;
  final String? coverImagePath;
  final TripCardLayout layout;

  @override
  Widget build(BuildContext context) {
    if (layout == TripCardLayout.plan) {
      return _buildTextLayout(context, showRating: false);
    }
    if (coverImagePath != null) {
      return _buildCoverLayout(context);
    }
    return _buildTextLayout(context, showRating: true);
  }

  Widget _buildTextLayout(BuildContext context, {required bool showRating}) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final range =
        '${DateFormat('dd/MM/yy', 'en').format(trip.startDate)} – ${DateFormat('dd/MM/yy', 'en').format(trip.endDate)}';
    final subtitle = [
      if (trip.countries.isNotEmpty)
        resolveGeography(trip.countries.first)?.name ?? trip.countries.first,
      if (trip.cities.isNotEmpty) trip.cities.first,
    ].join(', ');

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: trip.countries.take(4).map((name) {
                        final code = resolveGeography(name)?.code;
                        if (code == null) return const SizedBox.shrink();
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                            width: 24,
                            height: 16,
                            child: Flag.fromString(code, fit: BoxFit.cover),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.onSurfaceVariant,
                    size: 22,
                  ),
                ],
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                range,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (showRating)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        trip.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          height: 1.2,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          trip.averageDayRating != null
                              ? NumberFormat('#0.0', 'en')
                                  .format(trip.averageDayRating)
                              : '--',
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.star_rounded,
                          color: scheme.tertiary,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                )
              else
                Text(
                  trip.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1.2,
                    color: scheme.onSurface,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverLayout(BuildContext context) {
    final range =
        '${DateFormat('dd/MM/yy', 'en').format(trip.startDate)} - ${DateFormat('dd/MM/yy', 'en').format(trip.endDate)}';
    final subtitle = [
      if (trip.countries.isNotEmpty)
        resolveGeography(trip.countries.first)?.name ?? trip.countries.first,
      if (trip.cities.isNotEmpty) trip.cities.first,
    ].join(', ');

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (coverImagePath != null)
              Image.file(File(coverImagePath!), fit: BoxFit.cover)
            else
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: const Center(child: Icon(Icons.image_outlined, size: 36)),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: trip.countries.map(
                              (name) {
                                final code = resolveGeography(name)?.code;
                                if (code == null) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: SizedBox(
                                      width: 24,
                                      height: 16,
                                      child: Flag.fromString(code,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    range,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          trip.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            trip.averageDayRating != null
                                ? NumberFormat('#0.0', 'en').format(trip.averageDayRating)
                                : '--',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
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
