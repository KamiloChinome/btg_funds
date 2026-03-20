import 'package:btg_funds/core/domain/notification_method.dart';
import 'package:btg_funds/core/presentation/extensions.dart';
import 'package:btg_funds/core/presentation/formatters/cop_input_formatter.dart';
import 'package:btg_funds/core/presentation/widgets/app_snackbar.dart';
import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/portfolio/application/portfolio_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Bottom sheet form for subscribing to a fund.
/// Validates the amount against the fund minimum and user balance,
/// and requires selection of a notification method.
class SubscribeBottomSheet extends ConsumerStatefulWidget {
  const SubscribeBottomSheet({super.key, required this.fund});

  final Fund fund;

  @override
  ConsumerState<SubscribeBottomSheet> createState() =>
      _SubscribeBottomSheetState();
}

class _SubscribeBottomSheetState extends ConsumerState<SubscribeBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final portfolio = ref.watch(portfolioNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'subscribe.title'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Fund info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fund.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'fundCategory.${widget.fund.category.name}'.tr()}  •  '
                      '${'funds.minimum'.tr(namedArgs: {'amount': widget.fund.minimumAmount.toCOP()})}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Amount field
              Text(
                'subscribe.amountLabel'.tr(),
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              FormBuilderTextField(
                name: 'amount',
                initialValue: widget.fund.minimumAmount.toInt().toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CopInputFormatter(),
                ],
                decoration: InputDecoration(
                  prefixText: 'COP \$ ',
                  hintText: 'subscribe.amountHint'.tr(),
                  helperText: 'subscribe.availableBalance'.tr(
                    namedArgs: {'amount': portfolio.balance.toCOP()},
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'validators.amountRequired'.tr(),
                  ),
                  (value) {
                    final stripped =
                        CopInputFormatter.stripFormatting(value ?? '');
                    final amount = double.tryParse(stripped);
                    if (amount == null) {
                      return 'validators.amountInvalid'.tr();
                    }
                    if (amount < widget.fund.minimumAmount) {
                      return 'validators.amountBelowMinimum'.tr(
                        namedArgs: {
                          'amount': widget.fund.minimumAmount.toCOP(),
                        },
                      );
                    }
                    if (amount > portfolio.balance) {
                      return 'validators.amountExceedsBalance'.tr(
                        namedArgs: {'amount': portfolio.balance.toCOP()},
                      );
                    }
                    return null;
                  },
                ]),
              ),
              const SizedBox(height: 20),

              // Notification method selector
              Text(
                'subscribe.notificationMethod'.tr(),
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              FormBuilderRadioGroup<NotificationMethod>(
                name: 'notification_method',
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                options: NotificationMethod.values
                    .map(
                      (method) => FormBuilderFieldOption(
                        value: method,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              method == NotificationMethod.email
                                  ? Icons.email_outlined
                                  : Icons.sms_outlined,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text('notificationMethod.${method.name}'.tr()),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                validator: FormBuilderValidators.required(
                  errorText: 'validators.notificationRequired'.tr(),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _onSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('subscribe.button'.tr()),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Validates the form and processes the subscription.
  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    setState(() => _isSubmitting = true);

    final values = _formKey.currentState!.value;
    final rawAmount =
        CopInputFormatter.stripFormatting(values['amount'] as String);
    final amount = double.parse(rawAmount);
    final method = values['notification_method'] as NotificationMethod;

    // Simulate brief processing delay
    await Future.delayed(const Duration(milliseconds: 300));

    final result = ref.read(portfolioNotifierProvider.notifier).subscribe(
          fund: widget.fund,
          amount: amount,
          notificationMethod: method,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (failure) => showErrorSnackbar(context, failure.displayMessage),
      (_) {
        Navigator.of(context).pop();
        showSuccessSnackbar(
          context,
          'success.subscribed'.tr(namedArgs: {
            'fundName': widget.fund.name,
            'method': 'notificationMethod.${method.name}'.tr(),
          }),
        );
      },
    );
  }
}
