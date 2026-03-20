import 'package:btg_funds/core/domain/notification_method.dart';
import 'package:btg_funds/transactions/domain/transaction_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund_transaction.freezed.dart';

/// Domain model representing a fund transaction (subscription or cancellation).
/// Immutable record of every operation performed on the user's portfolio.
@freezed
sealed class FundTransaction with _$FundTransaction {
  const FundTransaction._();

  const factory FundTransaction({
    required String id,
    required String fundId,
    required String fundName,
    required TransactionType type,
    required double amount,
    required DateTime date,

    /// Only present for subscription transactions.
    NotificationMethod? notificationMethod,
  }) = _FundTransaction;
}
