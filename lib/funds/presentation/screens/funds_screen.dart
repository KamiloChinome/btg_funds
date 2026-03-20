import 'package:btg_funds/core/presentation/widgets/confirmation_bottom_sheet.dart';
import 'package:btg_funds/funds/application/funds_notifier.dart';
import 'package:btg_funds/funds/domain/fund_category.dart';
import 'package:btg_funds/funds/presentation/widgets/fund_card.dart';
import 'package:btg_funds/funds/presentation/widgets/funds_shimmer_list.dart';
import 'package:btg_funds/funds/presentation/widgets/subscribe_bottom_sheet.dart';
import 'package:btg_funds/portfolio/application/portfolio_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Screen displaying all available investment funds.
/// Shows loading, error, and data states with appropriate UI feedback.
/// Supports filtering by fund category using filter chips.
class FundsScreen extends HookConsumerWidget {
  const FundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fundsAsync = ref.watch(fundsNotifierProvider);
    final portfolio = ref.watch(portfolioNotifierProvider);
    final selectedCategory = useState<FundCategory?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text('funds.title'.tr()),
      ),
      body: fundsAsync.when(
        // Loading state — shimmer skeleton
        loading: () => const FundsShimmerList(),

        // Error state with retry
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.read(fundsNotifierProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: Text('retry'.tr()),
                ),
              ],
            ),
          ),
        ),

        // Data state — filter chips + fund list
        data: (funds) {
          final filteredFunds = selectedCategory.value == null
              ? funds
              : funds
                  .where((f) => f.category == selectedCategory.value)
                  .toList();

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(fundsNotifierProvider.notifier).refresh(),
            child: Column(
              children: [
                // Category filter chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      Text(
                        'funds.filterByCategory'.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        selected: selectedCategory.value == null,
                        label: Text('funds.filterAll'.tr()),
                        onSelected: (_) => selectedCategory.value = null,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        selected:
                            selectedCategory.value == FundCategory.fpv,
                        label: Text(
                          'fundCategory.fpv'.tr(),
                        ),
                        onSelected: (_) =>
                            selectedCategory.value = FundCategory.fpv,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        selected:
                            selectedCategory.value == FundCategory.fic,
                        label: Text(
                          'fundCategory.fic'.tr(),
                        ),
                        onSelected: (_) =>
                            selectedCategory.value = FundCategory.fic,
                      ),
                    ],
                  ),
                ),

                // Fund list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFunds.length,
                    itemBuilder: (context, index) {
                      final fund = filteredFunds[index];
                      final isSubscribed =
                          portfolio.isSubscribedTo(fund.id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FundCard(
                          fund: fund,
                          isSubscribed: isSubscribed,
                          currentBalance: portfolio.balance,
                          onSubscribe: () =>
                              _showSubscribeSheet(context, fund, ref),
                          onCancel: () => _showCancelConfirmation(
                            context,
                            ref,
                            fund.id,
                            fund.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Opens the subscribe bottom sheet for the selected fund.
  void _showSubscribeSheet(BuildContext context, fund, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => SubscribeBottomSheet(fund: fund),
    );
  }

  /// Shows a confirmation bottom sheet before cancelling a subscription.
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
