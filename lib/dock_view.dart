import 'package:flutter/material.dart';

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({super.key, required this.items, required this.builder});

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T, int) builder;

  @override
  DockState<T> createState() => DockState<T>();
}

class DockState<T> extends State<Dock<T>> {
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _items.asMap().entries.map((entry) {
        return widget.builder(entry.value, entry.key);
      }).toList(),
    );
  }
}
