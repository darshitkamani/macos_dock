import 'package:flutter/material.dart';

/// A widget that represents an individual feedback item in the dock.
class FeedbackItem extends StatelessWidget {
  /// Creates a [FeedbackItem] with the specified size, index, and icon.
  const FeedbackItem({
    super.key,
    required this.updatedIconSize,
    required this.index,
    required this.icon,
  });

  /// The size of the icon and container.
  final double updatedIconSize;

  /// The index of this feedback item (used to determine the color).
  final int index;

  /// The icon to be displayed inside the feedback item.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: updatedIconSize,
          width: updatedIconSize,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.accents[index % Colors.accents.length],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: updatedIconSize / 2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
