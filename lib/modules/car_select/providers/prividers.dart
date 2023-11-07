import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memorized/modules/car_select/models/car_bread.dart';

import '../../../core/http/http_provider.dart';
import '../models/car_group_state.dart';
import '../models/car_list_state.dart';
import '../repositories/repository.dart';
import '../repositories/repository_impl_mock.dart';

class CarGroupStateNotifier extends StateNotifier<CarGroupState> {
  final CarSelectRepository repository;
  CarGroupStateNotifier(this.repository) : super(CarGroupState()) {
    _init();
  }

  Future _init() async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final result = await repository.groupList();

    if (!mounted) {
      return;
    }

    if (result.isFailure) {
      state = state.copyWith(
          isLoading: false,
          isLoadingError: true,
          error: result.failure.message);
      return;
    }

    state = state.copyWith(
        isLoading: false,
        isLoadingError: false,
        error: null,
        carGroupList: result.success);
  }

  Future chageSelected(int groupIndex, int breadIndex) async {
    state = state.copyWith(
        selectGroupIndex: groupIndex, selectBreadIndex: breadIndex);
  }

  bool isSelected(int grpupIndex, int breadIndex) {
    return grpupIndex == state.selectGroupIndex &&
        breadIndex == state.selectBreadIndex;
  }

  CarBread getSelectedBread() {
    int grpupIndex = state.selectGroupIndex;
    int breadIndex = state.selectBreadIndex;
    return state.carGroupList[grpupIndex].breads[breadIndex];
  }
}

class CarListStateNotifier extends StateNotifier<CarListState> {
  final CarSelectRepository repository;
  final CarBread bread;
  CarListStateNotifier(this.repository, this.bread)
      : super(CarListState(bread: bread)) {
    load();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("CarListStateNotifier ${bread.name} dispose");
  }

  Future load() async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final result = await repository.carList(bread);

    if (!mounted) {
      return;
    }

    if (result.isFailure) {
      state = state.copyWith(
          isLoading: false,
          isLoadingError: true,
          error: result.failure.message);
      return;
    }

    state = state.copyWith(
        isLoading: false,
        isLoadingError: false,
        error: null,
        carList: result.success);
  }

  Future carSelect(int index) async {
    debugPrint("carSelect $index");
  }
}

//for test
final carSelectRepositoryProvider = Provider<CarSelectRepository>((ref) {
  final httpUtil = ref.read(httpUtilProvider);
  return CarSelectRepositoryImplMock(httpUtil);
});

final carGroupStateProvider =
    AutoDisposeStateNotifierProvider<CarGroupStateNotifier, CarGroupState>(
        ((ref) {
  return CarGroupStateNotifier(ref.read(carSelectRepositoryProvider));
}));

final carListStateProvider = AutoDisposeStateNotifierProviderFamily<
    CarListStateNotifier, CarListState, CarBread>(((ref, arg) {
  return CarListStateNotifier(ref.read(carSelectRepositoryProvider), arg);
}));
