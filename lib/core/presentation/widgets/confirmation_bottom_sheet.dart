import 'package:flutter/material.dart';

/// A reusable modal bottom sheet for confirmation actions.
///
/// Displays an icon, title, message, and two buttons (secondary + primary).
/// Can be used for cancel confirmations, delete prompts, etc.
class ConfirmationBottomSheet extends StatelessWidget {
  const ConfirmationBottomSheet({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryPressed,
    this.primaryColor,
  });

  /// The icon displayed at the top of the sheet.
  final IconData icon;

  /// Color applied to the icon.
  final Color iconColor;

  /// Title text shown below the icon.
  final String title;

  /// Descriptive message explaining the action.
  final String message;

  /// Label for the primary (destructive/confirm) button.
  final String primaryLabel;

  /// Label for the secondary (dismiss) button.
  final String secondaryLabel;

  /// Callback invoked when the primary button is pressed.
  final VoidCallback onPrimaryPressed;

  /// Optional color override for the primary button.
  /// Defaults to the theme's error color.
  final Color? primaryColor;

  /// Shows a [ConfirmationBottomSheet] as a modal bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String primaryLabel,
    required String secondaryLabel,
    required VoidCallback onPrimaryPressed,
    Color? primaryColor,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => ConfirmationBottomSheet(
        icon: icon,
        iconColor: iconColor,
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        secondaryLabel: secondaryLabel,
        onPrimaryPressed: onPrimaryPressed,
        primaryColor: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePrimaryColor = primaryColor ?? theme.colorScheme.error;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Primary (destructive) button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: effectivePrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPrimaryPressed();
                },
                child: Text(primaryLabel),
              ),
            ),
            const SizedBox(height: 12),

            // Secondary (dismiss) button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(secondaryLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
