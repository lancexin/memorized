import 'dart:async';

typedef Lazy<T> = T Function();

/// Represents a value of one of two possible types.
/// Instances of [Result] are either an instance of [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".
sealed class Result<L, R> {
  const Result();

  /// Represents the left side of [Either] class which by convention is a "Failure".
  bool get isFailure => this is Failure<L, R>;

  /// Represents the right side of [Either] class which by convention is a "Success"
  bool get isSuccess => this is Success<L, R>;

  /// Get [Left] value, may throw an exception when the value is [Right]
  L get failure => this.fold<L>(
      (value) => value,
      (success) => throw Exception(
          'Illegal use. You should check isLeft before calling'));

  /// Get [Right] value, may throw an exception when the value is [Left]
  R get success => this.fold<R>(
      (failure) => throw Exception(
          'Illegal use. You should check isRight before calling'),
      (value) => value);

  /// Transform values of [Left] and [Right]
  Result<TL, TR> either<TL, TR>(
      TL Function(L failure) fnL, TR Function(R success) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Result<L, TR> then<TR>(Result<L, TR> Function(R success) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Future<Result<L, TR>> thenAsync<TR>(
      FutureOr<Result<L, TR>> Function(R success) fnR);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Result<TL, R> thenFailure<TL>(Result<TL, R> Function(L failure) fnL);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Future<Result<TL, R>> thenFailureAsync<TL>(
      FutureOr<Result<TL, R>> Function(L failure) fnL);

  /// Transform value of [Right]
  Result<L, TR> map<TR>(TR Function(R success) fnR);

  /// Transform value of [Left]
  Result<TL, R> mapFailure<TL>(TL Function(L failure) fnL);

  /// Transform value of [Right]
  Future<Result<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R success) fnR);

  /// Transform value of [Left]
  Future<Result<TL, R>> mapFailureAsync<TL>(
      FutureOr<TL> Function(L failure) fnL);

  /// Fold [Left] and [Right] into the value of one type
  T fold<T>(T Function(L failure) fnL, T Function(R success) fnR);

  /// Swap [Left] and [Right]
  Result<R, L> swap() =>
      fold((failure) => Success(failure), (success) => Failure(success));

  /// Constructs a new [Either] from a function that might throw
  static Result<L, R> tryCatch<L, R, Err extends Object>(
      L Function(Err err) onError, R Function() fnR) {
    try {
      return Success(fnR());
    } on Err catch (e) {
      return Failure(onError(e));
    }
  }

  /// Constructs a new [Either] from a function that might throw
  ///
  /// simplified version of [Either.tryCatch]
  ///
  /// ```dart
  /// final fileOrError = Either.tryExcept<FileError>(() => /* maybe throw */);
  /// ```
  static Result<Err, R> tryExcept<Err extends Object, R>(R Function() fnR) {
    try {
      return Success(fnR());
    } on Err catch (e) {
      return Failure(e);
    }
  }

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Result<L, R> cond<L, R>(bool test, L failureValue, R successValue) =>
      test ? Success(successValue) : Failure(failureValue);

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Result<L, R> condLazy<L, R>(
          bool test, Lazy<L> failureValue, Lazy<R> successValue) =>
      test ? Success(successValue()) : Failure(failureValue());

  @override
  bool operator ==(Object other) {
    return this.fold(
      (failure) => other is Failure && failure == other.value,
      (success) => other is Success && success == other.value,
    );
  }

  @override
  int get hashCode =>
      fold((failure) => failure.hashCode, (success) => success.hashCode);
}

/// Used for "failure"
class Failure<L, R> extends Result<L, R> {
  final L value;

  const Failure(this.value);

  @override
  Result<TL, TR> either<TL, TR>(
      TL Function(L failure) fnL, TR Function(R success) fnR) {
    return Failure<TL, TR>(fnL(value));
  }

  @override
  Result<L, TR> then<TR>(Result<L, TR> Function(R success) fnR) {
    return Failure<L, TR>(value);
  }

  @override
  Future<Result<L, TR>> thenAsync<TR>(
      FutureOr<Result<L, TR>> Function(R success) fnR) {
    return Future.value(Failure<L, TR>(value));
  }

  @override
  Result<TL, R> thenFailure<TL>(Result<TL, R> Function(L failure) fnL) {
    return fnL(value);
  }

  @override
  Future<Result<TL, R>> thenFailureAsync<TL>(
      FutureOr<Result<TL, R>> Function(L failure) fnL) {
    return Future.value(fnL(value));
  }

  @override
  Result<L, TR> map<TR>(TR Function(R success) fnR) {
    return Failure<L, TR>(value);
  }

  @override
  Result<TL, R> mapFailure<TL>(TL Function(L failure) fnL) {
    return Failure<TL, R>(fnL(value));
  }

  @override
  Future<Result<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R success) fnR) {
    return Future.value(Failure<L, TR>(value));
  }

  @override
  Future<Result<TL, R>> mapFailureAsync<TL>(
      FutureOr<TL> Function(L failure) fnL) {
    return Future.value(fnL(value)).then((value) => Failure<TL, R>(value));
  }

  @override
  T fold<T>(T Function(L failure) fnL, T Function(R success) fnR) {
    return fnL(value);
  }
}

/// Used for "success" Right
class Success<L, R> extends Result<L, R> {
  final R value;

  const Success(this.value);

  @override
  Result<TL, TR> either<TL, TR>(
      TL Function(L failure) fnL, TR Function(R success) fnR) {
    return Success<TL, TR>(fnR(value));
  }

  @override
  Result<L, TR> then<TR>(Result<L, TR> Function(R success) fnR) {
    return fnR(value);
  }

  @override
  Future<Result<L, TR>> thenAsync<TR>(
      FutureOr<Result<L, TR>> Function(R success) fnR) {
    return Future.value(fnR(value));
  }

  @override
  Result<TL, R> thenFailure<TL>(Result<TL, R> Function(L failure) fnL) {
    return Success<TL, R>(value);
  }

  @override
  Future<Result<TL, R>> thenFailureAsync<TL>(
      FutureOr<Result<TL, R>> Function(L failure) fnL) {
    return Future.value(Success<TL, R>(value));
  }

  @override
  Result<L, TR> map<TR>(TR Function(R success) fnR) {
    return Success<L, TR>(fnR(value));
  }

  @override
  Result<TL, R> mapFailure<TL>(TL Function(L failure) fnL) {
    return Success<TL, R>(value);
  }

  @override
  Future<Result<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R success) fnR) {
    return Future.value(fnR(value)).then((value) => Success<L, TR>(value));
  }

  @override
  Future<Result<TL, R>> mapFailureAsync<TL>(
      FutureOr<TL> Function(L failure) fnL) {
    return Future.value(Success<TL, R>(value));
  }

  @override
  T fold<T>(T Function(L failure) fnL, T Function(R success) fnR) {
    return fnR(value);
  }
}
