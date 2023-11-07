// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CarListState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingError => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  CarBread? get bread => throw _privateConstructorUsedError;
  List<Car> get carList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CarListStateCopyWith<CarListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarListStateCopyWith<$Res> {
  factory $CarListStateCopyWith(
          CarListState value, $Res Function(CarListState) then) =
      _$CarListStateCopyWithImpl<$Res, CarListState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingError,
      String? error,
      CarBread? bread,
      List<Car> carList});
}

/// @nodoc
class _$CarListStateCopyWithImpl<$Res, $Val extends CarListState>
    implements $CarListStateCopyWith<$Res> {
  _$CarListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingError = null,
    Object? error = freezed,
    Object? bread = freezed,
    Object? carList = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingError: null == isLoadingError
          ? _value.isLoadingError
          : isLoadingError // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      bread: freezed == bread
          ? _value.bread
          : bread // ignore: cast_nullable_to_non_nullable
              as CarBread?,
      carList: null == carList
          ? _value.carList
          : carList // ignore: cast_nullable_to_non_nullable
              as List<Car>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CarListStateCopyWith<$Res>
    implements $CarListStateCopyWith<$Res> {
  factory _$$_CarListStateCopyWith(
          _$_CarListState value, $Res Function(_$_CarListState) then) =
      __$$_CarListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingError,
      String? error,
      CarBread? bread,
      List<Car> carList});
}

/// @nodoc
class __$$_CarListStateCopyWithImpl<$Res>
    extends _$CarListStateCopyWithImpl<$Res, _$_CarListState>
    implements _$$_CarListStateCopyWith<$Res> {
  __$$_CarListStateCopyWithImpl(
      _$_CarListState _value, $Res Function(_$_CarListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingError = null,
    Object? error = freezed,
    Object? bread = freezed,
    Object? carList = null,
  }) {
    return _then(_$_CarListState(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingError: null == isLoadingError
          ? _value.isLoadingError
          : isLoadingError // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      bread: freezed == bread
          ? _value.bread
          : bread // ignore: cast_nullable_to_non_nullable
              as CarBread?,
      carList: null == carList
          ? _value._carList
          : carList // ignore: cast_nullable_to_non_nullable
              as List<Car>,
    ));
  }
}

/// @nodoc

class _$_CarListState extends _CarListState {
  _$_CarListState(
      {this.isLoading = false,
      this.isLoadingError = false,
      this.error,
      this.bread,
      final List<Car> carList = const []})
      : _carList = carList,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingError;
  @override
  final String? error;
  @override
  final CarBread? bread;
  final List<Car> _carList;
  @override
  @JsonKey()
  List<Car> get carList {
    if (_carList is EqualUnmodifiableListView) return _carList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_carList);
  }

  @override
  String toString() {
    return 'CarListState(isLoading: $isLoading, isLoadingError: $isLoadingError, error: $error, bread: $bread, carList: $carList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CarListState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingError, isLoadingError) ||
                other.isLoadingError == isLoadingError) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.bread, bread) || other.bread == bread) &&
            const DeepCollectionEquality().equals(other._carList, _carList));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isLoadingError, error,
      bread, const DeepCollectionEquality().hash(_carList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CarListStateCopyWith<_$_CarListState> get copyWith =>
      __$$_CarListStateCopyWithImpl<_$_CarListState>(this, _$identity);
}

abstract class _CarListState extends CarListState {
  factory _CarListState(
      {final bool isLoading,
      final bool isLoadingError,
      final String? error,
      final CarBread? bread,
      final List<Car> carList}) = _$_CarListState;
  _CarListState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isLoadingError;
  @override
  String? get error;
  @override
  CarBread? get bread;
  @override
  List<Car> get carList;
  @override
  @JsonKey(ignore: true)
  _$$_CarListStateCopyWith<_$_CarListState> get copyWith =>
      throw _privateConstructorUsedError;
}
