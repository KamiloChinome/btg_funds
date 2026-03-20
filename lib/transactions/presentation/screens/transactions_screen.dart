import 'package:btg_funds/core/presentation/widgets/empty_state.dart';
import 'package:btg_funds/transactions/application/transactions_notifier.dart';
import 'package:btg_funds/transactions/presentation/widgets/transaction_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Screen displaying the full transaction history.
/// Shows subscriptions and cancellations ordered by date (newest first).
class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('transactions.title'.tr()),
      ),
      body: transactions.isEmpty
          ? EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'transactions.empty'.tr(),
              subtitle: 'transactions.emptySubtitle'.tr(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TransactionTile(transaction: transaction),
                );
              },
            ),
    );
  }
}
