import 'package:freezed_annotation/freezed_annotation.dart';

import 'car_group.dart';

part 'car_group_state.freezed.dart';

@freezed
class CarGroupState with _$CarGroupState {
  factory CarGroupState(
      {@Default(false) bool isLoading,
      @Default(false) bool isLoadingError,
      String? error,
      @Default(0) int selectGroupIndex,
      @Default(0) int selectBreadIndex,
      @Default([]) List<CarGroup> carGroupList}) = _CarGroupState;
  const CarGroupState._();

  static CarGroupState empty = CarGroupState();
}
