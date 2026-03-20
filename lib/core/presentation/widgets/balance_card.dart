import 'package:btg_funds/core/domain/notification_method.dart';
import 'package:btg_funds/core/presentation/widgets/animated_balance.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Prominent card displaying the user's current available balance.
/// Uses a gradient background to draw attention.
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'portfolio.availableBalance'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedBalance(
            balance: balance,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Informational chip showing the selected notification method.
class NotificationMethodChip extends StatelessWidget {
  const NotificationMethodChip({super.key, required this.method});

  final NotificationMethod method;

  @override
  Widget build(BuildContext context) {
    final icon = method == NotificationMethod.email
        ? Icons.email_outlined
        : Icons.sms_outlined;

    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text('notificationMethod.${method.name}'.tr()),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
