import 'package:btg_funds/core/domain/failure.dart';
import 'package:btg_funds/core/domain/notification_method.dart';
import 'package:btg_funds/core/presentation/extensions.dart';
import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/portfolio/application/portfolio_state.dart';
import 'package:btg_funds/portfolio/domain/subscription.dart';
import 'package:btg_funds/transactions/application/transactions_notifier.dart';
import 'package:btg_funds/transactions/domain/fund_transaction.dart';
import 'package:btg_funds/transactions/domain/transaction_type.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'portfolio_notifier.g.dart';

const _uuid = Uuid();

/// Notifier that manages the user's investment portfolio state.
/// Handles fund subscriptions and cancellations, validating business rules
/// and coordinating with the [TransactionsNotifier] for history tracking.
@Riverpod(keepAlive: true)
class PortfolioNotifier extends _$PortfolioNotifier {
  @override
  PortfolioState build() => PortfolioState.initial();

  /// Subscribes the user to a [fund] with the given [amount] and
  /// [notificationMethod].
  ///
  /// Validates:
  /// - The user is not already subscribed to the fund.
  /// - The amount meets the fund's minimum requirement.
  /// - The user has sufficient balance.
  ///
  /// On success, deducts the amount from the balance, adds the subscription,
  /// and records the transaction.
  Either<Failure, Unit> subscribe({
    required Fund fund,
    required double amount,
    required NotificationMethod notificationMethod,
  }) {
    // Check for existing subscription
    if (state.isSubscribedTo(fund.id)) {
      return left(Failure.alreadySubscribed(
        message: 'failure.alreadySubscribed'.tr(),
      ));
    }

    // Validate minimum amount
    if (amount < fund.minimumAmount) {
      return left(Failure.minimumAmountNotMet(
        message: 'failure.minimumAmountNotMet'.tr(
          namedArgs: {'amount': fund.minimumAmount.toCOP()},
        ),
      ));
    }

    // Validate sufficient balance
    if (state.balance < amount) {
      return left(Failure.insufficientBalance(
        message: 'failure.insufficientBalance'.tr(
          namedArgs: {'amount': state.balance.toCOP()},
        ),
      ));
    }

    // Create subscription
    final subscription = Subscription(
      fundId: fund.id,
      fundName: fund.name,
      amount: amount,
      date: DateTime.now(),
      notificationMethod: notificationMethod,
    );

    // Update portfolio state
    state = state.copyWith(
      balance: state.balance - amount,
      subscriptions: [...state.subscriptions, subscription],
    );

    // Record the transaction
    ref.read(transactionsNotifierProvider.notifier).addTransaction(
          FundTransaction(
            id: _uuid.v4(),
            fundId: fund.id,
            fundName: fund.name,
            type: TransactionType.subscription,
            amount: amount,
            date: DateTime.now(),
            notificationMethod: notificationMethod,
          ),
        );

    return right(unit);
  }

  /// Cancels the user's subscription to the fund identified by [fundId].
  ///
  /// Validates that the user is currently subscribed to the fund.
  /// On success, returns the invested amount to the balance, removes the
  /// subscription, and records the cancellation transaction.
  Either<Failure, Unit> cancel(String fundId) {
    final subscription = state.subscriptionFor(fundId);

    if (subscription == null) {
      return left(Failure.notSubscribed(
        message: 'failure.notSubscribed'.tr(),
      ));
    }

    // Update portfolio state — return invested amount to balance
    state = state.copyWith(
      balance: state.balance + subscription.amount,
      subscriptions:
          state.subscriptions.where((s) => s.fundId != fundId).toList(),
    );

    // Record the cancellation transaction
    ref.read(transactionsNotifierProvider.notifier).addTransaction(
          FundTransaction(
            id: _uuid.v4(),
            fundId: subscription.fundId,
            fundName: subscription.fundName,
            type: TransactionType.cancellation,
            amount: subscription.amount,
            date: DateTime.now(),
          ),
        );

    return right(unit);
  }
}
