import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that reacts to hover events, providing dynamic sizing and animations.
class HoverItem extends StatelessWidget {
  /// Creates a [HoverItem] with customizable properties and hover behaviors.
  const HoverItem({
    super.key,
    required this.baseIconSize,
    required this.updatedIconSize,
    required this.index,
    required this.paddingFromBottom,
    required this.hoveredItemIndex,
    required this.currentlySelectedIcon,
    required this.icon,
    required this.onHover,
    required this.onEnter,
    required this.onExit,
  });

  /// The base size of the icon when not hovered.
  final double baseIconSize;

  /// The updated size of the icon when hovered.
  final double updatedIconSize;

  /// The index of this item (used to determine color and hover status).
  final int index;

  /// The padding from the bottom of the container when hovered.
  final double paddingFromBottom;

  /// The index of the currently hovered item.
  final int hoveredItemIndex;

  /// The icon currently selected by the user.
  final IconData currentlySelectedIcon;

  /// The icon to display for this item.
  final IconData icon;

  /// Callback for handling hover events.
  final Function(PointerHoverEvent)? onHover;

  /// Callback for handling when the pointer enters the widget.
  final Function(PointerEnterEvent)? onEnter;

  /// Callback for handling when the pointer exits the widget.
  final Function(PointerExitEvent)? onExit;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MouseCursor.defer,
      onHover: onHover,
      onEnter: onEnter,
      onExit: onExit,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: baseIconSize, end: updatedIconSize),
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastLinearToSlowEaseIn,
        builder: (context, size, child) {
          return Opacity(
            opacity: ((hoveredItemIndex == index) &&
                    currentlySelectedIcon != Icons.abc)
                ? 0
                : 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: size,
                  width: size,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.accents[index % Colors.accents.length],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: size / 1.8,
                    color: Colors.white,
                  ),
                ),
                AnimatedContainer(
                  height: paddingFromBottom,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.fastLinearToSlowEaseIn,
                ),
                const SizedBox(height: 5),
                const Icon(
                  Icons.circle,
                  size: 3,
                  color: Colors.black,
                ),
                const SizedBox(height: 3),
              ],
            ),
          );
        },
      ),
    );
  }
}
