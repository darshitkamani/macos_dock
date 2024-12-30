import 'package:flutter/material.dart';
import 'package:macos_dock/dock_provider.dart';
import 'package:macos_dock/dock_view.dart';
import 'package:macos_dock/feedback_item.dart';
import 'package:macos_dock/hover_item.dart';
import 'package:provider/provider.dart';

/// View representing a dock with interactive items.
class DockItemView extends StatefulWidget {
  const DockItemView({super.key});

  @override
  State<DockItemView> createState() => _DockItemViewState();
}

class _DockItemViewState extends State<DockItemView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, DockProvider dockProvider, __) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            /// Background container for the dock.
            AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              width: dockProvider.containerWidth,
              padding: const EdgeInsets.all(5),
              duration: const Duration(milliseconds: 200),
              height: 70,
              curve: Curves.fastEaseInToSlowEaseOut,
            ),

            /// Dock containing draggable and hoverable icons.
            Positioned(
              key: dockProvider.containerKey,
              bottom: 0,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 120,
                padding: const EdgeInsets.all(5),
                duration: Duration(
                  milliseconds:
                      dockProvider.currentHoveredItemIndex != -1 ? 200 : 700,
                ),
                child: Dock(
                  items: dockProvider.dockIconList,

                  /// Builder to create each dock item.
                  builder: (item, index) {
                    // Retrieve updated icon size and padding values.
                    Map<String, dynamic> dockItem =
                        dockProvider.updateIconSize(currentIndex: index);

                    double updatedIconSize = dockItem['updatedIconSize'];
                    double paddingFromBottom = dockItem['paddingFromBottom'];
                    double baseIconSize = dockItem['baseIconSize'];

                    return (dockProvider.currentlySelectedIcon != Icons.abc &&
                            dockProvider.currentHoveredItemIndex == -1 &&
                            (dockProvider.dockIconList[index] ==
                                dockProvider.currentlySelectedIcon))
                        ? const SizedBox()
                        : DragTarget(
                            /// Creates a draggable icon for the dock.
                            builder: (context, candidateData, rejectedData) {
                              return Draggable(
                                onDragCompleted: dockProvider.onDragCompleted,
                                onDragEnd: (details) {
                                  dockProvider.onDragEnd();
                                },
                                onDraggableCanceled: (velocity, offset) {
                                  dockProvider.onDraggableCanceled();
                                },
                                onDragStarted: () {
                                  dockProvider.onDragStarted(index: index);
                                },
                                data: index,

                                /// Feedback shown while dragging.
                                feedback: FeedbackItem(
                                  updatedIconSize: updatedIconSize,
                                  index: index,
                                  icon: dockProvider.dockIconList[index],
                                ),

                                /// Hoverable and interactive item.
                                child: HoverItem(
                                  onHover: dockProvider.onHover,
                                  onEnter: (_) {
                                    dockProvider.onEnter(index: index);
                                  },
                                  onExit: (_) {
                                    dockProvider.onExit(index: index);
                                  },
                                  baseIconSize: baseIconSize,
                                  updatedIconSize: updatedIconSize,
                                  index: index,
                                  paddingFromBottom: paddingFromBottom,
                                  hoveredItemIndex:
                                      dockProvider.currentHoveredItemIndex,
                                  currentlySelectedIcon:
                                      dockProvider.currentlySelectedIcon,
                                  icon: dockProvider.dockIconList[index],
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
