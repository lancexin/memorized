import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memo_ui/memo_ui.dart';

import 'dart:math' as math;

import 'package:sliver_tools/sliver_tools.dart';

class Test1Page extends StatefulWidget {
  const Test1Page({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Test1Page> with TickerProviderStateMixin {
  static final actions = [
    MIconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
    MIconButton(icon: const Icon(Icons.event), onPressed: () {}),
    MIconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
  ];

  late final scrollController = ScrollController();

  late final AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this);

  late final MDraggableScrollableController draggableScrollableController;

  bool fill = false;

  bool _showList = false;

  bool get showList => _showList;

  set showList(bool show) {
    _showList = show;
    if (mounted) {
      var recognizer = VerticalDragGestureRecognizerCache.maybeOf(context)
          ?.verticalDragGestureRecognizer;
      if (show) {
        recognizer?.scrollViewOffset = 1;
      } else {
        recognizer?.scrollViewOffset = 0;
      }
    }
  }

  late final TabController tabController =
      TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    draggableScrollableController = MDraggableScrollableController();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (mounted) {
      var recognizer = VerticalDragGestureRecognizerCache.maybeOf(context)
          ?.verticalDragGestureRecognizer;
      recognizer?.scrollViewOffset = scrollController.position.pixels;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        NestedScrollView(
          physics: fill
              ? const NeverScrollableScrollPhysics()
              : const RangeMaintainingScrollPhysics(),
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            final slivers = <Widget>[
              SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: MultiSliver(children: [
                    _sliverAppBar(),
                    if (!fill) _tabbar(),
                  ]))
            ];

            return slivers;
          },
          body: fill
              ? const SizedBox.shrink()
              : TabBarView(controller: tabController, children: [
                  _tab1(),
                  _tab2(),
                ]),
        ),
        InteractiveBottomSheet(
          controller: draggableScrollableController,
          options: InteractiveBottomSheetOptions(
              maxHeigth:
                  MediaQuery.of(context).size.height - kToolbarHeight - 150,
              initialSize: 0.0,
              minimumSize: 0.0,
              maxSize: 1.0,
              snap: false),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Center(
                child: Text(
              "test",
              style: TextStyle(fontSize: 20),
            )),
          ),
        )
      ],
    );
  }

  Widget _tab1() {
    return Builder(builder: (context) {
      return CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverPinnedHeader(
            child: Container(
                height:
                    kToolbarHeight + MediaQuery.of(context).padding.top + 30),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
            ),
          ),
          SliverPersistentHeader(
              pinned: true,
              delegate: MSliverPersistentHeaderDelegate(
                  min: 40,
                  max: 40,
                  child: Container(color: Colors.lightGreen))),
          _sliverAnimatedList()
        ],
      );
    });
  }

  Widget _tab2() {
    return Builder(builder: (context) {
      return CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverPinnedHeader(
            child: Container(
                height:
                    kToolbarHeight + MediaQuery.of(context).padding.top + 30),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
            ),
          ),
          SliverPersistentHeader(
              pinned: true,
              delegate: MSliverPersistentHeaderDelegate(
                  min: 40, max: 40, child: Container(color: Colors.red))),
          _sliverAnimatedList()
        ],
      );
    });
  }

  Widget _tabbar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MSliverPersistentHeaderDelegate(
          child: ColoredBox(
              color: Colors.black,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 30,
                      child: TabBar(
                          controller: tabController,
                          indicatorColor:
                              const Color.fromARGB(255, 113, 93, 78),
                          dividerColor: Colors.transparent,
                          indicatorWeight: 4,
                          tabs: const [
                            Text(
                              "Tab1",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Tab2",
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                    )),
                    const Spacer()
                  ],
                ),
              )),
          max: 30,
          min: 30),
    );
  }

  Widget _sliverAppBar() {
    return SliverAnimatedAppBar(
      title: const MText("Text1"),
      leading: const MCloseButton(),
      actions: actions,
      expandedHeight: fill
          ? MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.bottom +
                  MediaQuery.of(context).padding.top)
          : showList
              ? 150
              : 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          color: const Color.fromARGB(255, 113, 93, 78),
          child: Stack(
            children: [
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        fill = !fill;
                      });
                    },
                    icon: fill
                        ? const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.fullscreen_exit_outlined,
                            color: Colors.white,
                          ),
                  )),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        setState(() {
                          showList = !showList;
                          if (showList) {
                            draggableScrollableController.animateTo(
                                MediaQuery.of(context).size.height -
                                    kToolbarHeight -
                                    150,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear);
                          } else {
                            draggableScrollableController.animateTo(0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear);
                          }
                        });
                      });
                    },
                    icon: showList
                        ? const Icon(
                            Icons.list,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.list_alt,
                            color: Colors.white,
                          ),
                  ))
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget _sliverAnimatedList() {
    return SliverFixedExtentList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return SizedBox(
          height: 40,
          child: Center(child: Text("Text $index")),
        );
      }, childCount: 100),
      itemExtent: 50,
    );
  }
}

class MText extends StatefulWidget {
  final String data;
  const MText(this.data, {super.key});

  @override
  State<StatefulWidget> createState() => _MTextState();
}

class _MTextState extends State<MText> {
  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

    final double deltaExtent = settings.maxExtent - settings.minExtent;
    final double fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
    const double fadeEnd = 1.0;
    final double t = clampDouble(
        1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent,
        0.0,
        1.0);
    // If the min and max extent are the same, the app bar cannot collapse
    // and the content should be visible, so opacity = 1.
    final double opacity = settings.maxExtent == settings.minExtent
        ? 1.0
        : 1.0 - Interval(fadeStart, fadeEnd).transform(t);
    return Text(
      widget.data,
      style: TextStyle(
          color: opacity < 0.5
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.surface),
    );
  }
}

class MSliverChildDelegate extends SliverChildDelegate {
  @override
  Widget? build(BuildContext context, int index) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  bool shouldRebuild(covariant SliverChildDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    throw UnimplementedError();
  }
}

class MIconButton extends StatefulWidget {
  final Icon icon;
  final void Function()? onPressed;
  const MIconButton({super.key, this.onPressed, required this.icon});

  @override
  State<StatefulWidget> createState() => _MIconButtonState();
}

class _MIconButtonState extends State<MIconButton> {
  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

    final double deltaExtent = settings.maxExtent - settings.minExtent;
    final double fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
    const double fadeEnd = 1.0;
    final double t = clampDouble(
        1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent,
        0.0,
        1.0);
    // If the min and max extent are the same, the app bar cannot collapse
    // and the content should be visible, so opacity = 1.
    final double opacity = settings.maxExtent == settings.minExtent
        ? 1.0
        : 1.0 - Interval(fadeStart, fadeEnd).transform(t);
    return IconButton(
      color: opacity < 0.5
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.surface,
      icon: widget.icon,
      onPressed: widget.onPressed,
    );
  }
}

class MCloseButton extends StatefulWidget {
  const MCloseButton({super.key});

  @override
  State<StatefulWidget> createState() => _MCloseButtonState();
}

class _MCloseButtonState extends State<MCloseButton> {
  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

    final double deltaExtent = settings.maxExtent - settings.minExtent;
    final double fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
    const double fadeEnd = 1.0;
    final double t = clampDouble(
        1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent,
        0.0,
        1.0);
    // If the min and max extent are the same, the app bar cannot collapse
    // and the content should be visible, so opacity = 1.
    final double opacity = settings.maxExtent == settings.minExtent
        ? 1.0
        : 1.0 - Interval(fadeStart, fadeEnd).transform(t);
    return CloseButton(
        color: opacity < 0.5
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.surface);
  }
}

class MSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  final double max;

  final double min;

  const MSliverPersistentHeaderDelegate(
      {required this.child, required this.max, required this.min});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;
}
