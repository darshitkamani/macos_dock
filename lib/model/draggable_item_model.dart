import 'package:flutter/material.dart';

/// A model class representing a draggable item in the dock.
class DraggableItemModel {
  /// The index of the item in the list.
  final int index;

  /// The icon data associated with the item.
  final IconData iconData;

  /// Constructor to initialize a [DraggableItemModel] with the provided [index] and [iconData].
  DraggableItemModel({
    required this.index,
    required this.iconData,
  });
}
