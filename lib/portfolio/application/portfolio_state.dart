import 'package:btg_funds/portfolio/domain/subscription.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_state.freezed.dart';

/// State representing the user's investment portfolio.
/// Contains the available balance and the list of active subscriptions.
@freezed
sealed class PortfolioState with _$PortfolioState {
  const PortfolioState._();

  const factory PortfolioState({
    required double balance,
    required List<Subscription> subscriptions,
  }) = _PortfolioState;

  /// Initial state with default balance of COP $500,000 and no subscriptions.
  factory PortfolioState.initial() => const PortfolioState(
        balance: 500000,
        subscriptions: [],
      );

  /// Checks if the user is subscribed to a fund by its [fundId].
  bool isSubscribedTo(String fundId) =>
      subscriptions.any((s) => s.fundId == fundId);

  /// Returns the subscription for a given [fundId], or null if not subscribed.
  Subscription? subscriptionFor(String fundId) =>
      subscriptions.where((s) => s.fundId == fundId).firstOrNull;
}
