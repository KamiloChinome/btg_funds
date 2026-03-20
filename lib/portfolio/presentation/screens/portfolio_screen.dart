import 'package:btg_funds/core/presentation/extensions.dart';
import 'package:btg_funds/core/presentation/widgets/balance_card.dart';
import 'package:btg_funds/core/presentation/widgets/confirmation_bottom_sheet.dart';
import 'package:btg_funds/core/presentation/widgets/empty_state.dart';
import 'package:btg_funds/funds/presentation/router.dart';
import 'package:btg_funds/portfolio/application/portfolio_notifier.dart';
import 'package:btg_funds/portfolio/presentation/widgets/subscription_card.dart';
import 'package:btg_funds/transactions/application/transactions_notifier.dart';
import 'package:btg_funds/transactions/presentation/router.dart';
import 'package:btg_funds/transactions/presentation/widgets/transaction_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Main portfolio screen showing the user's balance, a summary,
/// active subscriptions, and recent transactions.
class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  /// Max number of recent transactions to show in the preview.
  static const _recentTransactionsLimit = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioNotifierProvider);
    final transactions = ref.watch(transactionsNotifierProvider);
    final theme = Theme.of(context);

    final totalInvested = portfolio.subscriptions.fold<double>(
      0,
      (sum, s) => sum + s.amount,
    );
    final recentTransactions = transactions.take(
      _recentTransactionsLimit,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Balance card
          BalanceCard(balance: portfolio.balance),
          const SizedBox(height: 16),

          // ---- Summary Section ----
          _SectionTitle(title: 'portfolio.summary'.tr()),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.savings_outlined,
                  label: 'portfolio.totalInvested'.tr(),
                  value: totalInvested.toCOP(),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.pie_chart_outline,
                  label: 'portfolio.fundsActive'.tr(),
                  value: portfolio.subscriptions.length.toString(),
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ---- My Subscriptions Section ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionTitle(title: 'portfolio.mySubscriptions'.tr()),
              Text(
                'portfolio.activeCount'.tr(
                  namedArgs: {
                    'count': portfolio.subscriptions.length.toString(),
                  },
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (portfolio.subscriptions.isEmpty)
            EmptyState(
              icon: Icons.trending_up_outlined,
              title: 'portfolio.noSubscriptions'.tr(),
              subtitle: 'portfolio.noSubscriptionsSubtitle'.tr(),
              action: ElevatedButton.icon(
                onPressed: () => const FundsRoute().go(context),
                icon: const Icon(Icons.search),
                label: Text('portfolio.browseFunds'.tr()),
              ),
            )
          else
            ...portfolio.subscriptions.map(
              (subscription) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SubscriptionCard(
                  subscription: subscription,
                  onCancel: () => _showCancelConfirmation(
                    context,
                    ref,
                    subscription.fundId,
                    subscription.fundName,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24),

          // ---- Recent Transactions Section ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionTitle(title: 'portfolio.recentTransactions'.tr()),
              if (transactions.isNotEmpty)
                TextButton(
                  onPressed: () => const TransactionsRoute().go(context),
                  child: Text('portfolio.viewAll'.tr()),
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (recentTransactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'portfolio.noRecentTransactions'.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...recentTransactions.map(
              (transaction) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TransactionTile(transaction: transaction),
              ),
            ),
        ],
      ),
    );
  }

  /// Shows a confirmation bottom sheet before cancelling a fund subscription.
  void _showCancelConfirmation(
    BuildContext context,
    WidgetRef ref,
    String fundId,
    String fundName,
  ) {
    ConfirmationBottomSheet.show(
      context: context,
      icon: Icons.cancel_outlined,
      iconColor: Theme.of(context).colorScheme.error,
      title: 'cancel.title'.tr(),
      message: 'cancel.message'.tr(namedArgs: {'fundName': fundName}),
      primaryLabel: 'cancel.confirm'.tr(),
      secondaryLabel: 'cancel.keep'.tr(),
      onPrimaryPressed: () {
        final result = ref
            .read(portfolioNotifierProvider.notifier)
            .cancel(fundId);

        result.fold(
          (failure) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.displayMessage),
              backgroundColor: Colors.red.shade700,
            ),
          ),
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'success.cancelled'.tr(
                  namedArgs: {'fundName': fundName},
                ),
              ),
              backgroundColor: Colors.green.shade700,
            ),
          ),
        );
      },
    );
  }
}

/// Reusable section title with bold styling.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// Compact summary card showing a metric with icon, label, and value.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
