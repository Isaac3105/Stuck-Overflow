import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/day.dart';

/// Returns 1–5, or null if dismissed (only when [barrierDismissible] is true).
Future<int?> showDayRatingSheet(
  BuildContext context, {
  required TripDay day,
  required String title,
  String? subtitle,
  bool barrierDismissible = true,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isDismissible: barrierDismissible,
    enableDrag: barrierDismissible,
    showDragHandle: true,
    builder: (ctx) {
      return _DayRatingSheetBody(
        day: day,
        title: title,
        subtitle: subtitle,
        barrierDismissible: barrierDismissible,
      );
    },
  );
}

class _DayRatingSheetBody extends StatefulWidget {
  const _DayRatingSheetBody({
    required this.day,
    required this.title,
    this.subtitle,
    required this.barrierDismissible,
  });

  final TripDay day;
  final String title;
  final String? subtitle;
  final bool barrierDismissible;

  @override
  State<_DayRatingSheetBody> createState() => _DayRatingSheetBodyState();
}

class _DayRatingSheetBodyState extends State<_DayRatingSheetBody> {
  int _stars = 3;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('EEEE, MMMM d', 'en').format(widget.day.date);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              dateLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(widget.subtitle!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final n = i + 1;
                final filled = n <= _stars;
                return IconButton(
                  iconSize: 40,
                  onPressed: () => setState(() => _stars = n),
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: filled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (widget.barrierDismissible)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _stars),
                    child: const Text('Save'),
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
