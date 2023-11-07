import 'package:flutter/material.dart';

import '../../core/shimmer/placeholders.dart';
import '../../core/shimmer/shimmer.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _State();
}

class _State extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        bl = !bl;
      });
    });
  }

  bool bl = true;
  @override
  Widget build(BuildContext context) {
    Widget child = SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: bl ? const BannerPlaceholder2() : const BannerPlaceholder(),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                key: ValueKey<Key?>(child.key),
                opacity: animation,
                child: child,
              );
            },
          ),
          const TitlePlaceholder(width: double.infinity),
          const SizedBox(height: 16.0),
          const ContentPlaceholder(
            lineType: ContentLineType.threeLines,
          ),
          const SizedBox(height: 16.0),
          const TitlePlaceholder(width: 200.0),
          const SizedBox(height: 16.0),
          const ContentPlaceholder(
            lineType: ContentLineType.twoLines,
          ),
          const SizedBox(height: 16.0),
          const TitlePlaceholder(width: 200.0),
          const SizedBox(height: 16.0),
          const ContentPlaceholder(
            lineType: ContentLineType.twoLines,
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Loading List'),
      ),
      body: bl
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: child)
          : child,
    );
  }
}
