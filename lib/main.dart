import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:macos_dock/model/draggable_item_model.dart';
import 'package:macos_dock/custom_reorderable_list_view.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MacOSDocApp());
}

/// [Widget] building the [MaterialApp].
class MacOSDocApp extends StatefulWidget {
  const MacOSDocApp({super.key});

  @override
  State<MacOSDocApp> createState() => _MacOSDocAppState();
}

class _MacOSDocAppState extends State<MacOSDocApp> {
  List<IconData> dockItemList = const [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: dockItemList,
            builder: (e) {
              return Center(child: Icon(e, color: Colors.white));
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T extends Object?> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T extends Object?> extends State<Dock<T>> {
  ScrollController scrollController = ScrollController();

  ///Global Key for the [Dock] used to get the current offset
  final GlobalKey _containerKey = GlobalKey();

  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  /// Stores the model for the draggable item
  DraggableItemModel? draggableItem;

  /// Tracks the index of the hovered item for hover effects.
  late int? hoveredIndex;

  /// Defines the base height of dock items before hover effects.
  late double baseItemHeight;

  /// Defines the base vertical translation of dock items before hover effects.
  late double baseTranslationY;

  /// Calculates the scaled size of an item based on its index and hover state.
  double getScaledSize(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseItemHeight,
      maxValue: 55,
      nonHoveredMaxValue: 50,
    );
  }

  /// Calculates the Y-axis translation of an item based on its index and hover state.
  double getTranslationY(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseTranslationY,
      maxValue: -22,
      nonHoveredMaxValue: -14,
    );
  }

  /// Returns a property value (size or translation) based on the hover state and item index.
  double getPropertyValue({
    required int index,
    required double baseValue,
    required double maxValue,
    required double nonHoveredMaxValue,
  }) {
    late final double propertyValue;

    /// If no item is hovered, return the base value.
    if (hoveredIndex == null) {
      return baseValue;
    }

    final difference = (hoveredIndex! - index).abs();
    final itemsAffected = _items.length;

    /// If the item is the hovered one, set the property value to the max value.
    if (difference == 0) {
      propertyValue = maxValue;
    }

    /// If the item is close to the hovered one, linearly interpolate between max values.
    else if (difference <= itemsAffected) {
      final ratio = (itemsAffected - difference) / itemsAffected;
      propertyValue = lerpDouble(baseValue, nonHoveredMaxValue, ratio)!;
    } else {
      propertyValue = baseValue;
    }

    return propertyValue;
  }

  @override
  void initState() {
    super.initState();

    hoveredIndex = null;
    baseItemHeight = 40;
    baseTranslationY = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCornerOffsets();
    });
  }

  Offset _topLeftOffset = Offset.zero;
  Offset _topRightOffset = Offset.zero;
  Offset _bottomLeftOffset = Offset.zero;
  Offset _bottomRightOffset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: _containerKey,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomReorderableListView(
            onReorderEnd: (i) {
              setState(() {
                // hoveredIndex = null;
              });
            },
            bottomLeft: _bottomLeftOffset,
            bottomRight: _bottomRightOffset,
            topLeft: _topLeftOffset,
            topRight: _topRightOffset,
            dragStartBehavior: DragStartBehavior.down,
            scrollController: scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            onReorder: _onReorder,
            children: _items.map((item) {
              int index = _items.indexOf(item);
              return MouseRegion(
                key: ValueKey(item),
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() {
                  hoveredIndex = index;
                }),
                onExit: (_) => setState(() {
                  hoveredIndex = null;
                }),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.identity()
                      ..translate(
                        0.0,
                        getTranslationY(index),
                        0.0,
                      ),
                    height: getScaledSize(index),
                    width: getScaledSize(index),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors
                          .primaries[item.hashCode % Colors.primaries.length],
                    ),
                    child: widget.builder(item)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Reorders the items in the list when an item is dragged and dropped to a new position.
  void _onReorder(int oldIndex, int newIndex) {
    _getCornerOffsets();
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final T item = _items.removeAt(oldIndex);
      hoveredIndex = newIndex;
      _items.insert(newIndex, item);
    });
  }

  void _getCornerOffsets() {
    final RenderBox renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox;
    final position =
        renderBox.localToGlobal(Offset.zero); // Position relative to parent

    // Set the four corners' offsets
    setState(() {
      _topLeftOffset = position; // Top-left corner (dx, dy)
      _topRightOffset = Offset(position.dx + renderBox.size.width + 50,
          position.dy + 50); // Top-right corner (dx + width, dy)
      _bottomLeftOffset = Offset(
          position.dx,
          position.dy +
              renderBox.size.height +
              50); // Bottom-left corner (dx, dy + height)
      _bottomRightOffset = Offset(
          position.dx + renderBox.size.width + 50,
          position.dy +
              renderBox.size.height +
              50); // Bottom-right corner (dx + width, dy + height)
    });
  }
}
