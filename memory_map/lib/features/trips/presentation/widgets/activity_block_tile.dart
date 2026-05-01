import 'package:flutter/material.dart';

import '../../domain/activity_block.dart';

class ActivityBlockTile extends StatelessWidget {
  const ActivityBlockTile({
    super.key,
    required this.block,
    this.onTap,
    this.onLongPress,
    this.dense = false,
  });

  final ActivityBlock block;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: dense ? 10 : 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    block.startLabel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 2,
                    height: 18,
                    color: scheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    block.endLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (block.locationText != null &&
                        block.locationText!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              block.locationText!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (!dense &&
                        block.notes != null &&
                        block.notes!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        block.notes!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
