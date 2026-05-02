import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/geography.dart';
import '../../../media/photo_thumbnail.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';

/// [cover] — photo hero when [coverImagePath] is set; otherwise same text card
/// as archive-style (flags, dates, name, rating).
/// [plan] — text-only for planning (no rating, no image).
enum TripCardLayout { cover, plan }

class TripCard extends StatefulWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
    this.coverMedia,
    this.layout = TripCardLayout.cover,
  });

  final Trip trip;
  final VoidCallback onTap;
  final MediaItem? coverMedia;
  final TripCardLayout layout;

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layout == TripCardLayout.plan) {
      return _buildSharedLayout(context, showImage: false, showRating: false);
    }
    if (widget.coverMedia != null) {
      return _buildCoverLayout(context);
    }
    return _buildSharedLayout(context, showImage: false, showRating: true);
  }

  Widget _buildSharedLayout(BuildContext context,
      {required bool showImage, required bool showRating}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final range =
        '${DateFormat('dd/MM/yy', 'en').format(widget.trip.startDate)} – ${DateFormat('dd/MM/yy', 'en').format(widget.trip.endDate)}';

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            if (widget.coverMedia != null)
              MediaThumbnail(
                type: widget.coverMedia!.type,
                filePath: widget.coverMedia!.filePath,
                borderRadius: 0,
              )
            else
              Container(color: scheme.surfaceContainerHigh),

            // Gradient Overlay for both (subtle for text, stronger for image)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: showImage
                      ? [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ]
                      : [
                          scheme.surface.withValues(alpha: 0.1),
                          Colors.transparent,
                          scheme.surface.withValues(alpha: 0.05),
                        ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Top Flags Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.trip.countries.length > 4)
                        Icon(
                          Icons.chevron_left_rounded,
                          size: 16,
                          color: showImage ? Colors.white : scheme.onSurface,
                        ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.trip.countries.map((name) {
                              final code = resolveGeography(name)?.code;
                              if (code == null) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: SizedBox(
                                    width: 24,
                                    height: 16,
                                    child: Flag.fromString(code, fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (widget.trip.countries.length > 4)
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: showImage ? Colors.white : scheme.onSurface,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Date Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    range,
                    style: textTheme.bodySmall?.copyWith(
                      color: showImage
                          ? Colors.white.withValues(alpha: 0.85)
                          : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const Spacer(),

                // Bottom Info
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.trip.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: showImage ? Colors.white : scheme.onSurface,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            height: 1.1,
                            shadows: showImage
                                ? [
                                    const Shadow(
                                      color: Colors.black45,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                      if (showRating) ...[
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.trip.averageDayRating != null
                                  ? NumberFormat('#0.0', 'en')
                                      .format(widget.trip.averageDayRating)
                                  : '--',
                              style: textTheme.bodyMedium?.copyWith(
                                color: showImage ? Colors.white : scheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverLayout(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final range =
        '${DateFormat('dd/MM/yy', 'en').format(widget.trip.startDate)} – ${DateFormat('dd/MM/yy', 'en').format(widget.trip.endDate)}';

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.coverMedia != null)
              MediaThumbnail(
                type: widget.coverMedia!.type,
                filePath: widget.coverMedia!.filePath,
                borderRadius: 0,
              )
            else
              Container(color: scheme.surfaceContainerHigh),

            // Gradient Overlay
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

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Top Flags Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.trip.countries.length > 4)
                        const Icon(
                          Icons.chevron_left_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.trip.countries.map((name) {
                              final code = resolveGeography(name)?.code;
                              if (code == null) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: SizedBox(
                                    width: 24,
                                    height: 16,
                                    child: Flag.fromString(code, fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (widget.trip.countries.length > 4)
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Date Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    range,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const Spacer(),

                // Bottom Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.trip.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            height: 1.1,
                            shadows: [
                              const Shadow(
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
                            widget.trip.averageDayRating != null
                                ? NumberFormat('#0.0', 'en')
                                    .format(widget.trip.averageDayRating)
                                : '--',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
