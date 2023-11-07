import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'draggable_scrollable_sheet.dart';

/// Options class.
class InteractiveBottomSheetOptions {
  ///  Contains all options for customization of the InteractiveBottomSheet.
  const InteractiveBottomSheetOptions({
    this.backgroundColor = Colors.white,
    this.expand = false,
    this.snap = true,
    this.maxSize = 1,
    this.maxHeigth,
    this.initialSize = 0.25,
    this.minimumSize = 0.25,
    this.snapList = const [0.5],
  }) : assert(
          minimumSize <= initialSize,
          'MinimumSize must be smaller than or equal to initialSize.',
        );

  /// The background color of the whole widget.
  final Color backgroundColor;

  /// Decides, if the sheet snaps to the nearest position declared in snapList
  /// when if the user stops dragging.
  final bool snap;

  /// Decides, if the widget should expand to fill the available space in its
  /// parent or not.
  final bool expand;

  /// The initial height of the bottom sheet, goes from 0.0 to 1.0.
  /// Note that using values under 0.1 might create problems
  /// dragging the widget at all.
  final double initialSize;

  /// The maximum height of the bottom sheet.
  final double maxSize;
  final double? maxHeigth;

  /// The minimum height of the bottom sheet. The minimumSize must be smaller
  /// than or equal to initialSize.
  final double minimumSize;

  /// If snap is true, the bottom sheets snaps to the nearest point declared
  /// in this list when the user stops dragging.
  final List<double> snapList;
}

/// Options class for the DraggableArea.
class DraggableAreaOptions {
  ///  Contains all options for customization of the DraggableArea.
  const DraggableAreaOptions({
    this.topBorderRadius = 0.0,
    this.height = 50.0,
    this.backgroundColor = Colors.white,
    this.indicatorColor = Colors.black,
    this.indicatorWidth = 60.0,
    this.indicatorHeight = 5.0,
    this.indicatorRadius = 5.0,
    this.shadows = const [BoxShadow(color: Colors.grey, blurRadius: 1)],
  });

  /// Top Radius of the bottom sheet. To see it, a transparent background color
  /// for the bottomSheetTheme is necessary.
  final double topBorderRadius;

  /// The height of the DraggableArea.
  final double height;

  /// The color of the DraggableArea.
  final Color backgroundColor;

  /// The color of the Indicator.
  final Color indicatorColor;

  /// The width of the Indicator.
  final double indicatorWidth;

  /// The height of the Indicator.
  final double indicatorHeight;

  /// The top radius of the Indicator.
  final double indicatorRadius;

  /// Defines the shadow beneath the DraggableArea.
  final List<BoxShadow> shadows;
}

/// The InteractiveBottomSheet.
class InteractiveBottomSheet extends StatefulWidget {
  /// Should be placed inside the bottomSheet property of a Scaffold.
  const InteractiveBottomSheet({
    super.key,
    this.controller,
    this.options = const InteractiveBottomSheetOptions(),
    this.draggableAreaOptions = const DraggableAreaOptions(),
    this.child,
  });

  /// Customization options for the [InteractiveBottomSheet].
  final InteractiveBottomSheetOptions options;

  /// Customization options for the DraggableArea.
  final DraggableAreaOptions draggableAreaOptions;

  /// Optional Widget placed inside the [InteractiveBottomSheet].
  final Widget? child;

  final MDraggableScrollableController? controller;
  @override
  State<InteractiveBottomSheet> createState() => _InteractiveBottomSheetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<InteractiveBottomSheetOptions>(
          'options',
          options,
        ),
      )
      ..add(
        DiagnosticsProperty<DraggableAreaOptions>(
          'draggableAreaOptions',
          draggableAreaOptions,
        ),
      );
  }
}

class _InteractiveBottomSheetState extends State<InteractiveBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.options.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.draggableAreaOptions.topBorderRadius),
        ),
      ),
      child: MDraggableScrollableSheet(
        expand: widget.options.expand,
        snap: widget.options.snap,
        initialChildSize: widget.options.initialSize,
        minChildSize: widget.options.minimumSize,
        maxChildSize: widget.options.maxSize,
        maxChildHeigth: widget.options.maxHeigth,
        snapSizes: widget.options.snapList,
        controller: widget.controller,
        builder: (context, scrollController) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: widget.draggableAreaOptions.height,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: widget.child,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                child: _InteractiveBottomSheetDraggableArea(
                  options: widget.draggableAreaOptions,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InteractiveBottomSheetDraggableArea extends StatelessWidget {
  const _InteractiveBottomSheetDraggableArea({
    required this.options,
  });

  final DraggableAreaOptions options;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: options.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(options.topBorderRadius),
        ),
        boxShadow: options.shadows,
      ),
      height: options.height,
      child: Center(
        child: Container(
          height: options.indicatorHeight,
          width: options.indicatorWidth,
          decoration: BoxDecoration(
            color: options.indicatorColor,
            borderRadius: BorderRadius.all(
              Radius.circular(
                options.indicatorRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<DraggableAreaOptions>('options', options));
  }
}
