// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_group_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CarGroupState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingError => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get selectGroupIndex => throw _privateConstructorUsedError;
  int get selectBreadIndex => throw _privateConstructorUsedError;
  List<CarGroup> get carGroupList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CarGroupStateCopyWith<CarGroupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarGroupStateCopyWith<$Res> {
  factory $CarGroupStateCopyWith(
          CarGroupState value, $Res Function(CarGroupState) then) =
      _$CarGroupStateCopyWithImpl<$Res, CarGroupState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingError,
      String? error,
      int selectGroupIndex,
      int selectBreadIndex,
      List<CarGroup> carGroupList});
}

/// @nodoc
class _$CarGroupStateCopyWithImpl<$Res, $Val extends CarGroupState>
    implements $CarGroupStateCopyWith<$Res> {
  _$CarGroupStateCopyWithImpl(this._value, this._then);

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
    Object? selectGroupIndex = null,
    Object? selectBreadIndex = null,
    Object? carGroupList = null,
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
      selectGroupIndex: null == selectGroupIndex
          ? _value.selectGroupIndex
          : selectGroupIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectBreadIndex: null == selectBreadIndex
          ? _value.selectBreadIndex
          : selectBreadIndex // ignore: cast_nullable_to_non_nullable
              as int,
      carGroupList: null == carGroupList
          ? _value.carGroupList
          : carGroupList // ignore: cast_nullable_to_non_nullable
              as List<CarGroup>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CarGroupStateCopyWith<$Res>
    implements $CarGroupStateCopyWith<$Res> {
  factory _$$_CarGroupStateCopyWith(
          _$_CarGroupState value, $Res Function(_$_CarGroupState) then) =
      __$$_CarGroupStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingError,
      String? error,
      int selectGroupIndex,
      int selectBreadIndex,
      List<CarGroup> carGroupList});
}

/// @nodoc
class __$$_CarGroupStateCopyWithImpl<$Res>
    extends _$CarGroupStateCopyWithImpl<$Res, _$_CarGroupState>
    implements _$$_CarGroupStateCopyWith<$Res> {
  __$$_CarGroupStateCopyWithImpl(
      _$_CarGroupState _value, $Res Function(_$_CarGroupState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingError = null,
    Object? error = freezed,
    Object? selectGroupIndex = null,
    Object? selectBreadIndex = null,
    Object? carGroupList = null,
  }) {
    return _then(_$_CarGroupState(
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
      selectGroupIndex: null == selectGroupIndex
          ? _value.selectGroupIndex
          : selectGroupIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectBreadIndex: null == selectBreadIndex
          ? _value.selectBreadIndex
          : selectBreadIndex // ignore: cast_nullable_to_non_nullable
              as int,
      carGroupList: null == carGroupList
          ? _value._carGroupList
          : carGroupList // ignore: cast_nullable_to_non_nullable
              as List<CarGroup>,
    ));
  }
}

/// @nodoc

class _$_CarGroupState extends _CarGroupState {
  _$_CarGroupState(
      {this.isLoading = false,
      this.isLoadingError = false,
      this.error,
      this.selectGroupIndex = 0,
      this.selectBreadIndex = 0,
      final List<CarGroup> carGroupList = const []})
      : _carGroupList = carGroupList,
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
  @JsonKey()
  final int selectGroupIndex;
  @override
  @JsonKey()
  final int selectBreadIndex;
  final List<CarGroup> _carGroupList;
  @override
  @JsonKey()
  List<CarGroup> get carGroupList {
    if (_carGroupList is EqualUnmodifiableListView) return _carGroupList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_carGroupList);
  }

  @override
  String toString() {
    return 'CarGroupState(isLoading: $isLoading, isLoadingError: $isLoadingError, error: $error, selectGroupIndex: $selectGroupIndex, selectBreadIndex: $selectBreadIndex, carGroupList: $carGroupList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CarGroupState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingError, isLoadingError) ||
                other.isLoadingError == isLoadingError) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectGroupIndex, selectGroupIndex) ||
                other.selectGroupIndex == selectGroupIndex) &&
            (identical(other.selectBreadIndex, selectBreadIndex) ||
                other.selectBreadIndex == selectBreadIndex) &&
            const DeepCollectionEquality()
                .equals(other._carGroupList, _carGroupList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isLoadingError,
      error,
      selectGroupIndex,
      selectBreadIndex,
      const DeepCollectionEquality().hash(_carGroupList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CarGroupStateCopyWith<_$_CarGroupState> get copyWith =>
      __$$_CarGroupStateCopyWithImpl<_$_CarGroupState>(this, _$identity);
}

abstract class _CarGroupState extends CarGroupState {
  factory _CarGroupState(
      {final bool isLoading,
      final bool isLoadingError,
      final String? error,
      final int selectGroupIndex,
      final int selectBreadIndex,
      final List<CarGroup> carGroupList}) = _$_CarGroupState;
  _CarGroupState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isLoadingError;
  @override
  String? get error;
  @override
  int get selectGroupIndex;
  @override
  int get selectBreadIndex;
  @override
  List<CarGroup> get carGroupList;
  @override
  @JsonKey(ignore: true)
  _$$_CarGroupStateCopyWith<_$_CarGroupState> get copyWith =>
      throw _privateConstructorUsedError;
}
