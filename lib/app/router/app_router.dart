import 'package:btg_funds/app/presentation/main_scaffold.dart';
import 'package:btg_funds/funds/presentation/router.dart' as funds_router;
import 'package:btg_funds/portfolio/presentation/router.dart' as portfolio_router;
import 'package:btg_funds/preferences/presentation/router.dart' as settings_router;
import 'package:btg_funds/transactions/presentation/router.dart' as transactions_router;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigator keys for each bottom navigation branch.
/// Required by StatefulShellRoute to maintain separate navigation stacks.
final _portfolioKey = GlobalKey<NavigatorState>(debugLabel: 'portfolio');
final _fundsKey = GlobalKey<NavigatorState>(debugLabel: 'funds');
final _transactionsKey = GlobalKey<NavigatorState>(debugLabel: 'transactions');
final _settingsKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// Application router configuration using GoRouter with typed routes.
/// Uses [StatefulShellRoute.indexedStack] to provide persistent bottom
/// navigation across the four main tabs.
final appRouter = GoRouter(
  initialLocation: const portfolio_router.PortfolioRoute().location,
  routes: [
    // Redirect root to portfolio
    GoRoute(path: '/', redirect: (_, _) => const portfolio_router.PortfolioRoute().location),

    // Bottom navigation shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainScaffold(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _portfolioKey,
          initialLocation: const portfolio_router.PortfolioRoute().location,
          routes: [portfolio_router.$portfolioRoute],
        ),
        StatefulShellBranch(
          navigatorKey: _fundsKey,
          initialLocation: const funds_router.FundsRoute().location,
          routes: [funds_router.$fundsRoute],
        ),
        StatefulShellBranch(
          navigatorKey: _transactionsKey,
          initialLocation: const transactions_router.TransactionsRoute().location,
          routes: [transactions_router.$transactionsRoute],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsKey,
          initialLocation: const settings_router.SettingsRoute().location,
          routes: [settings_router.$settingsRoute],
        ),
      ],
    ),
  ],
);
