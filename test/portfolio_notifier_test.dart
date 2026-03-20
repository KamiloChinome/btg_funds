import 'package:btg_funds/core/domain/failure.dart';
import 'package:btg_funds/core/domain/notification_method.dart';
import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/funds/domain/fund_category.dart';
import 'package:btg_funds/portfolio/application/portfolio_notifier.dart';
import 'package:btg_funds/transactions/application/transactions_notifier.dart';
import 'package:btg_funds/transactions/domain/transaction_type.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  late ProviderContainer container;

  const testFund = Fund(
    id: '1',
    name: 'FPV_BTG_PACTUAL_RECAUDADORA',
    minimumAmount: 75000,
    category: FundCategory.fpv,
  );

  const expensiveFund = Fund(
    id: '4',
    name: 'FDO-ACCIONES',
    minimumAmount: 250000,
    category: FundCategory.fic,
  );

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('PortfolioNotifier', () {
    test('initial state has correct balance and empty subscriptions', () {
      final state = container.read(portfolioNotifierProvider);

      expect(state.balance, 500000);
      expect(state.subscriptions, isEmpty);
    });

    group('subscribe', () {
      test('succeeds with valid amount and updates balance', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        final result = notifier.subscribe(
          fund: testFund,
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );

        expect(result, isA<Right<Failure, Unit>>());

        final state = container.read(portfolioNotifierProvider);
        expect(state.balance, 425000);
        expect(state.subscriptions.length, 1);
        expect(state.subscriptions.first.fundId, '1');
        expect(state.subscriptions.first.amount, 75000);
      });

      test('records transaction on successful subscription', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        notifier.subscribe(
          fund: testFund,
          amount: 75000,
          notificationMethod: NotificationMethod.sms,
        );

        final transactions =
            container.read(transactionsNotifierProvider);
        expect(transactions.length, 1);
        expect(transactions.first.type, TransactionType.subscription);
        expect(transactions.first.fundId, '1');
        expect(transactions.first.amount, 75000);
        expect(
          transactions.first.notificationMethod,
          NotificationMethod.sms,
        );
      });

      test('fails with insufficient balance', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        // Subscribe to expensive fund to use up most balance
        notifier.subscribe(
          fund: expensiveFund,
          amount: 250000,
          notificationMethod: NotificationMethod.email,
        );

        // Try another expensive subscription
        final result = notifier.subscribe(
          fund: testFund,
          amount: 300000,
          notificationMethod: NotificationMethod.email,
        );

        expect(result, isA<Left<Failure, Unit>>());
        result.fold(
          (failure) => expect(failure, isA<InsufficientBalance>()),
          (_) => fail('Should have failed'),
        );
      });

      test('fails when below minimum amount', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        final result = notifier.subscribe(
          fund: testFund,
          amount: 50000, // Below minimum of 75000
          notificationMethod: NotificationMethod.email,
        );

        expect(result, isA<Left<Failure, Unit>>());
        result.fold(
          (failure) => expect(failure, isA<MinimumAmountNotMet>()),
          (_) => fail('Should have failed'),
        );
      });

      test('fails when already subscribed', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        // First subscription succeeds
        notifier.subscribe(
          fund: testFund,
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );

        // Second subscription to same fund fails
        final result = notifier.subscribe(
          fund: testFund,
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );

        expect(result, isA<Left<Failure, Unit>>());
        result.fold(
          (failure) => expect(failure, isA<AlreadySubscribed>()),
          (_) => fail('Should have failed'),
        );
      });

      test('allows multiple subscriptions to different funds', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        final result1 = notifier.subscribe(
          fund: testFund,
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );

        final result2 = notifier.subscribe(
          fund: expensiveFund,
          amount: 250000,
          notificationMethod: NotificationMethod.sms,
        );

        expect(result1, isA<Right<Failure, Unit>>());
        expect(result2, isA<Right<Failure, Unit>>());

        final state = container.read(portfolioNotifierProvider);
        expect(state.balance, 175000);
        expect(state.subscriptions.length, 2);
      });
    });

    group('cancel', () {
      test('succeeds and returns amount to balance', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        // Subscribe first
        notifier.subscribe(
          fund: testFund,
          amount: 100000,
          notificationMethod: NotificationMethod.email,
        );

        expect(
          container.read(portfolioNotifierProvider).balance,
          400000,
        );

        // Cancel
        final result = notifier.cancel('1');
        expect(result, isA<Right<Failure, Unit>>());

        final state = container.read(portfolioNotifierProvider);
        expect(state.balance, 500000);
        expect(state.subscriptions, isEmpty);
      });

      test('records cancellation transaction', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        notifier.subscribe(
          fund: testFund,
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );

        notifier.cancel('1');

        final transactions =
            container.read(transactionsNotifierProvider);
        expect(transactions.length, 2);
        // Newest first
        expect(
          transactions.first.type,
          TransactionType.cancellation,
        );
        expect(transactions.first.amount, 75000);
      });

      test('fails when not subscribed', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        final result = notifier.cancel('999');

        expect(result, isA<Left<Failure, Unit>>());
        result.fold(
          (failure) => expect(failure, isA<NotSubscribed>()),
          (_) => fail('Should have failed'),
        );
      });
    });

    group('isSubscribedTo', () {
      test('returns true for subscribed fund', () {
        final notifier =
            container.read(portfolioNotifierProvider.notifier);

        notifier.subscribe(
          fund: testFund,
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );

        final state = container.read(portfolioNotifierProvider);
        expect(state.isSubscribedTo('1'), true);
        expect(state.isSubscribedTo('2'), false);
      });
    });
  });
}
