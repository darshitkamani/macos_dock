import 'package:flutter/material.dart';

/// A provider class managing the state and behavior of the dock.
class DockProvider extends ChangeNotifier {
  /// Global key to access the container's context for measuring width.
  final GlobalKey containerKey = GlobalKey();

  /// List of icons displayed in the dock.
  List<IconData> _dockIconList = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  /// Getter for the dock icon list.
  List<IconData> get dockIconList => _dockIconList;

  /// Setter for the dock icon list with state update.
  set dockIconList(List<IconData> items) {
    _dockIconList = items;
    notifyListeners();
  }

  /// Currently selected icon in the dock.
  IconData _currentlySelectedIcon = Icons.abc;

  /// Getter for the currently selected icon.
  IconData get currentlySelectedIcon => _currentlySelectedIcon;

  /// Setter for the currently selected icon with state update.
  set currentlySelectedIcon(IconData icon) {
    _currentlySelectedIcon = icon;
    notifyListeners();
  }

  /// Index of the currently hovered dock item.
  int _currentHoveredItemIndex = -1;

  /// Getter for the currently hovered item index.
  int get currentHoveredItemIndex => _currentHoveredItemIndex;

  /// Setter for the currently hovered item index with state update.
  set currentHoveredItemIndex(int index) {
    _currentHoveredItemIndex = index;
    notifyListeners();
  }

  /// Index of the previously hovered dock item.
  int _previousHoveredIndex = -1;

  /// Getter for the previously hovered item index.
  int get previousHoveredIndex => _previousHoveredIndex;

  /// Setter for the previously hovered item index with state update.
  set previousHoveredIndex(int value) {
    _previousHoveredIndex = value;
    notifyListeners();
  }

  /// X-position of the hover pointer over the dock.
  double _hoverIconPositionX = 0.0;

  /// Getter for the hover pointer's X-position.
  double get hoverIconPositionX => _hoverIconPositionX;

  /// Setter for the hover pointer's X-position with state update.
  set hoverIconPositionX(double value) {
    _hoverIconPositionX = value;
    notifyListeners();
  }

  /// Width of the dock container.
  double _containerWidth = 0.0;

  /// Getter for the dock container's width.
  double get containerWidth => _containerWidth;

  /// Setter for the dock container's width with state update.
  set containerWidth(double value) {
    _containerWidth = value;
    notifyListeners();
  }

  /// Calculates and updates the container's width using its render box.
  void getContainerWidth() {
    if (containerKey.currentContext == null) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      final RenderBox renderBox =
          containerKey.currentContext!.findRenderObject() as RenderBox;

      containerWidth = renderBox.size.width;
    });
  }

  /// Updates the size and padding of icons based on their hover status.
  Map<String, dynamic> updateIconSize({required int currentIndex}) {
    double initialIconSize = 40;
    double bottomPadding = 0;
    double updatedIconSize = initialIconSize;
    double zoomIconSize = 10;

    if (currentHoveredItemIndex != -1) {
      int distance = (currentIndex - currentHoveredItemIndex).abs();

      // Manage icon size and padding based on hover index
      if (distance == 0) {
        updatedIconSize = (initialIconSize - 10) + zoomIconSize * 4;
        bottomPadding = 10;
      } else if (distance == 1) {
        updatedIconSize = (initialIconSize - 10) + zoomIconSize * 3;
        bottomPadding = 5;

        // Additional size adjustment based on hover
        if ((currentHoveredItemIndex >= 0 && currentHoveredItemIndex <= 30) &&
            (currentIndex - currentHoveredItemIndex).isNegative) {
          int size =
              ((initialIconSize - hoverIconPositionX) * (10 / initialIconSize))
                  .round();
          updatedIconSize = (initialIconSize - 10) + (zoomIconSize * 3) + size;
          bottomPadding = 10;
        } else if ((hoverIconPositionX >= 51 && hoverIconPositionX <= 80) &&
            !(currentIndex - currentHoveredItemIndex).isNegative) {
          int size =
              ((initialIconSize - hoverIconPositionX) * (10 / initialIconSize))
                  .round();
          updatedIconSize = (initialIconSize - 10) + (zoomIconSize * 3) - size;
          bottomPadding = 10;
        }
      } else if (distance == 2) {
        updatedIconSize = (initialIconSize - 10) + zoomIconSize * 2;
      } else if (distance == 3) {
        updatedIconSize = (initialIconSize - 10) + zoomIconSize;
      }
    }

    return {
      'updatedIconSize': updatedIconSize.toDouble(),
      'paddingFromBottom': bottomPadding.toDouble(),
      'baseIconSize': initialIconSize.toDouble(),
    };
  }

  /// Resets the selected icon when dragging is canceled.
  void onDraggableCanceled() {
    currentlySelectedIcon = Icons.abc;
  }

  /// Handles behavior when dragging starts.
  void onDragStarted({required int index}) {
    currentlySelectedIcon = dockIconList[index];
    getContainerWidth();
  }

  /// Handles behavior when dragging is completed.
  void onDragCompleted() {
    currentlySelectedIcon = Icons.abc;
    getContainerWidth();
  }

  /// Resets states when dragging ends.
  void onDragEnd() {
    currentlySelectedIcon = Icons.abc;
    previousHoveredIndex = -1;
    getContainerWidth();
  }

  /// Updates hover position and container width while hovering.
  void onHover(PointerEvent details) {
    hoverIconPositionX = details.localPosition.dx;
    getContainerWidth();
  }

  /// Handles behavior when hover exits an item.
  void onExit({required int index}) {
    previousHoveredIndex = index;
    currentHoveredItemIndex = -1;
    getContainerWidth();
  }

  /// Handles behavior when hover enters an item.
  void onEnter({required int index}) {
    currentHoveredItemIndex = index;
    if (currentlySelectedIcon != Icons.abc) {
      if (previousHoveredIndex != -1) {
        dockIconList[previousHoveredIndex] = dockIconList[index];
      }
      dockIconList[index] = currentlySelectedIcon;
    }
    getContainerWidth();
  }
}
