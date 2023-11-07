import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/car.dart';
import 'models/car_bread.dart';
import 'models/car_group.dart';
import 'models/car_group_state.dart';
import 'providers/prividers.dart';

class CarSelectPage extends StatelessWidget {
  const CarSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("选择品牌"),
        ),
        body: const _Body());
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __BodyState();
}

class __BodyState extends ConsumerState<_Body> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final carGroupState = ref.watch(carGroupStateProvider);
    if (carGroupState.isLoading) {
      return _loading();
    } else if (carGroupState.isLoadingError) {
      return _error(carGroupState.error);
    }
    return _data(carGroupState);
  }

  Widget _loading() {
    return const Center(
      child: Text("loading"),
    );
  }

  Widget _data(CarGroupState state) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _groupListWidget(state),
        ),
        Expanded(
          flex: 3,
          child: _carListWidget(state),
        )
      ],
    );
  }

  Widget _groupListWidget(CarGroupState state) {
    return CustomScrollView(
      slivers: state.carGroupList
          .asMap()
          .map<int, Widget>(_buildGroup)
          .values
          .toList(),
    );
  }

  Widget _carListWidget(CarGroupState state) {
    return Consumer(builder: (
      BuildContext context,
      WidgetRef ref,
      Widget? child,
    ) {
      final carGroupStateNotifier = ref.watch(carGroupStateProvider.notifier);
      final bread = carGroupStateNotifier.getSelectedBread();
      final privider = carListStateProvider(bread);
      var state = ref.watch(privider);
      var stateNotifier = ref.watch(privider.notifier);
      return CustomScrollView(
        slivers: [
          SliverPadding(
              padding: EdgeInsets.only(bottom: 20),
              sliver: SliverToBoxAdapter(
                  child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 5, right: 5.0),
                    child: FlutterLogo(size: 50),
                  ),
                  Text(
                    bread.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ))),
          SliverPadding(
              padding: EdgeInsets.only(bottom: 20),
              sliver: SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      height: 20,
                      child: Text("选择车系")))),
          SliverPadding(
              padding: EdgeInsets.only(bottom: 20),
              sliver: SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      height: 20,
                      child: Text("不限车系")))),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) =>
                  _buildCar(index, stateNotifier, state.carList[index]),
              childCount: state.carList.length,
            ),
          )
        ],
      );
    });
  }

  MapEntry<int, Widget> _buildGroup(int groupIndex, CarGroup grpup) {
    Widget widget = SliverMainAxisGroup(slivers: [
      SliverPersistentHeader(
        pinned: false,
        delegate: HeaderDelegate(grpup.name),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => _buildBread(groupIndex, index, grpup.breads[index]),
          childCount: grpup.breads.length,
        ),
      ),
    ]);
    return MapEntry(groupIndex, widget);
  }

  Widget _buildCar(int index, CarListStateNotifier notifier, Car car) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      child: GestureDetector(
          onTap: () {
            notifier.carSelect(index);
          },
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 5.0),
                child: FlutterLogo(size: 25),
              ),
              Text(
                car.name,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          )),
    );
  }

  Widget _buildBread(int groupIndex, int breadIndex, CarBread bread) {
    var notifier = ref.read(carGroupStateProvider.notifier);
    bool selected = notifier.isSelected(groupIndex, breadIndex);
    return Container(
      alignment: Alignment.center,
      color: selected ? Colors.grey : null,
      height: 40,
      child: GestureDetector(
          onTap: () {
            notifier.chageSelected(groupIndex, breadIndex);
          },
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 5.0),
                child: FlutterLogo(size: 25),
              ),
              Text(
                bread.name,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          )),
    );
  }
}

Widget _error(String? error) {
  return Center(
    child: Text(error?.toString() ?? "error"),
  );
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  const HeaderDelegate(this.title);

  final String title;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        height: 20,
        child: Text(title));
  }

  @override
  double get maxExtent => 20;

  @override
  double get minExtent => 20;

  @override
  bool shouldRebuild(covariant HeaderDelegate oldDelegate) =>
      title != oldDelegate.title;
}
