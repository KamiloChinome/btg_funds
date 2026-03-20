import 'package:btg_funds/app/theme/app_colors.dart';
import 'package:btg_funds/core/presentation/extensions.dart';
import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/funds/domain/fund_category.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Card widget displaying a single fund's information.
/// Shows name, category badge, minimum amount, and action buttons
/// based on the subscription status.
class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.isSubscribed,
    required this.currentBalance,
    required this.onSubscribe,
    required this.onCancel,
  });

  final Fund fund;
  final bool isSubscribed;
  final double currentBalance;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAfford = currentBalance >= fund.minimumAmount;
    final categoryColor = fund.category == FundCategory.fpv
        ? AppColors.fpvCategory
        : AppColors.ficCategory;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: category badge + subscription status
            Row(
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: categoryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'fundCategory.${fund.category.name}'.tr(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (isSubscribed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 14,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'funds.subscribed'.tr(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Fund name
            Text(
              fund.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Minimum amount
            Row(
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  'funds.minimum'.tr(
                    namedArgs: {'amount': fund.minimumAmount.toCOP()},
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action button
            SizedBox(
              width: double.infinity,
              child: isSubscribed
                  ? OutlinedButton.icon(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                      ),
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text('funds.cancelSubscription'.tr()),
                    )
                  : ElevatedButton.icon(
                      onPressed: canAfford ? onSubscribe : null,
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text(
                        canAfford
                            ? 'funds.subscribe'.tr()
                            : 'funds.insufficientBalance'.tr(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
