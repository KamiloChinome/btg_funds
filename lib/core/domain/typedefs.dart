import 'package:btg_funds/core/domain/failure.dart';
import 'package:dartz/dartz.dart';

/// Shorthand for a [Future] that returns an [Either] with a [Failure] or [T].
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Shorthand for an [Either] with a [Failure] or [T].
typedef EitherFailure<T> = Either<Failure, T>;
