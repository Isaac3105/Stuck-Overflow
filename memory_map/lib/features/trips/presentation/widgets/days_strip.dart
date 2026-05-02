import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/day.dart';

class DaysStrip extends StatelessWidget {
  const DaysStrip({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<TripDay> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dfDay = DateFormat('d', 'en');
    final dfMonth = DateFormat('MMM', 'en');
    final dfWeekday = DateFormat('EEE', 'en');
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final d = days[i];
          final selected = i == selectedIndex;
          return InkWell(
            onTap: () => onSelect(i),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 64,
              decoration: BoxDecoration(
                color: selected ? scheme.primary : scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dfWeekday.format(d.date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dfDay.format(d.date),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: selected ? scheme.onPrimary : scheme.onSurface,
                    ),
                  ),
                  Text(
                    dfMonth.format(d.date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                  if (d.dayRating != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '★ ${d.dayRating}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: selected ? scheme.onPrimary : scheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
