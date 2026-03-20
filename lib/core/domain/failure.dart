import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Sealed union type representing all possible failures in the application.
/// Each variant carries a human-readable [message] for UI display.
@freezed
sealed class Failure with _$Failure {
  const Failure._();

  /// The user does not have enough balance to complete the operation.
  const factory Failure.insufficientBalance({
    String? message,
  }) = InsufficientBalance;

  /// The provided amount does not meet the fund's minimum requirement.
  const factory Failure.minimumAmountNotMet({
    String? message,
  }) = MinimumAmountNotMet;

  /// The user is already subscribed to the requested fund.
  const factory Failure.alreadySubscribed({
    String? message,
  }) = AlreadySubscribed;

  /// The user is not subscribed to the requested fund.
  const factory Failure.notSubscribed({
    String? message,
  }) = NotSubscribed;

  /// A fund with the given ID was not found.
  const factory Failure.fundNotFound({
    String? message,
  }) = FundNotFound;

  /// An unexpected or unidentified failure.
  const factory Failure.unexpected({
    String? message,
    dynamic cause,
    StackTrace? stackTrace,
  }) = Unexpected;

  /// Returns the display message for UI consumption.
  /// Falls back to the failure key if [message] is null.
  String get displayMessage => message ?? 'failure.unexpected';
}
