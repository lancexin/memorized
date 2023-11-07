import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memo_ui/memo_ui.dart';
import 'package:sliver_tools/src/multi_sliver.dart';

import 'dart:math' as math;

import '../../core/log.dart';

class Test2Page extends StatefulWidget {
  const Test2Page({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Test2Page> with TickerProviderStateMixin {
  static final actions = [
    MIconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
    MIconButton(icon: const Icon(Icons.event), onPressed: () {}),
    MIconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
  ];

  late final scrollController = ScrollController();
  late final scrollController2 = ScrollController();

  late final AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this);

  bool fill = false;

  bool _showList = false;

  bool get showList => _showList;

  late final TabController tabController =
      TabController(length: 2, vsync: this);

  set showList(bool show) {
    _showList = show;
    if (mounted) {
      var recognizer = VerticalDragGestureRecognizerCache.maybeOf(context)!
          .verticalDragGestureRecognizer;
      if (show) {
        recognizer.scrollViewOffset = 1;
      } else {
        recognizer.scrollViewOffset = 0;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    //scrollController2.addListener(_scrollListener2);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    //scrollController2.removeListener(_scrollListener2);
    super.dispose();
  }

  void _scrollListener() {
    if (mounted) {
      var recognizer = VerticalDragGestureRecognizerCache.maybeOf(context)!
          .verticalDragGestureRecognizer;
      recognizer.scrollViewOffset = scrollController.position.pixels;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slivers = [
      _sliverAppBar(),
    ];

    if (!fill) {
      slivers.add(_sliverChild1());
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: fill
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            controller: scrollController,
            slivers: slivers,
          ),
          Positioned(
              bottom: 0,
              top: 150 + kToolbarHeight,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(animationController),
                child: Container(
                    color: Colors.orange,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      primary: false,
                      controller: scrollController2,
                      itemExtent: 40,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            color: Colors.black54,
                            child: Center(child: Text("Text $index")),
                          ),
                          onTap: () {
                            Log.d("ontap Text3 $index");
                          },
                        );
                      },
                      itemCount: 50,
                    )),
              ))
        ],
      ),
    );
  }

  Widget _sliverChild1() {
    return MultiSliver(key: const ValueKey<String>("_sliverChild1"), children: [
      SliverPersistentHeader(
        pinned: true,
        delegate: MSliverPersistentHeaderDelegate(
            child: ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
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
      ),
      SliverToBoxAdapter(
        child: Container(
          height: 100,
          color: Colors.red,
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: MSliverPersistentHeaderDelegate(
            child: ColoredBox(
              color: Colors.blue,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FilledButton(
                        onPressed: () async {}, child: const Text("t")),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FilledButton(
                        onPressed: () async {}, child: const Text("test23333")),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FilledButton(
                        onPressed: () async {}, child: const Text("test")),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FilledButton(
                        onPressed: () async {}, child: const Text("test2")),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FilledButton(
                        onPressed: () async {}, child: const Text("test2")),
                  ),
                ],
              ),
            ),
            max: 40,
            min: 40),
      ),
      _sliverAnimatedList()
    ]);
  }

  Widget _sliverAppBar() {
    return SliverAnimatedAppBar(
      title: const MText("Text2"),
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
                        Log.d("$fill");
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
                        showList = !showList;
                        if (showList) {
                          animationController.forward();
                        } else {
                          animationController.reverse();
                        }
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
        return GestureDetector(
          child: SizedBox(
            height: 40,
            child: Center(child: Text("Text $index")),
          ),
          onTap: () {
            Log.d("ontap Text $index");
          },
        );
      }, childCount: 30),
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
