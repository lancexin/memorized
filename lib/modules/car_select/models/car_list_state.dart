import 'package:freezed_annotation/freezed_annotation.dart';

import 'car.dart';
import 'car_bread.dart';

part 'car_list_state.freezed.dart';

@freezed
class CarListState with _$CarListState {
  factory CarListState(
      {@Default(false) bool isLoading,
      @Default(false) bool isLoadingError,
      String? error,
      CarBread? bread,
      @Default([]) List<Car> carList}) = _CarListState;
  const CarListState._();
}
