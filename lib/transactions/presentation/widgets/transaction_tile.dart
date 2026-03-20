import 'package:btg_funds/app/theme/app_colors.dart';
import 'package:btg_funds/core/presentation/extensions.dart';
import 'package:btg_funds/transactions/domain/fund_transaction.dart';
import 'package:btg_funds/transactions/domain/transaction_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Tile widget displaying a single transaction record.
/// Uses visual cues (color, icon) to distinguish between
/// subscription and cancellation transactions.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final FundTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubscription = transaction.type == TransactionType.subscription;
    final dateFormat = DateFormat('MMM dd, yyyy – hh:mm a');

    final color = isSubscription ? AppColors.success : AppColors.error;
    final icon = isSubscription
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    final sign = isSubscription ? '-' : '+';

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          transaction.fundName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${'transactionType.${transaction.type.name}'.tr()}'
              '${transaction.notificationMethod != null ? ' • ${'notificationMethod.${transaction.notificationMethod!.name}'.tr()}' : ''}',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              dateFormat.format(transaction.date),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        trailing: Text(
          '$sign${transaction.amount.toCOP()}',
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
