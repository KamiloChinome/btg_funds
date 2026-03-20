import 'package:btg_funds/transactions/domain/fund_transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_notifier.g.dart';

/// Notifier that manages the transaction history.
/// Keeps an in-memory list of all fund transactions (subscriptions and
/// cancellations), ordered by date (newest first).
@Riverpod(keepAlive: true)
class TransactionsNotifier extends _$TransactionsNotifier {
  @override
  List<FundTransaction> build() => [];

  /// Adds a new transaction to the history.
  /// Inserts at the beginning to maintain newest-first order.
  void addTransaction(FundTransaction transaction) {
    state = [transaction, ...state];
  }
}
