import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main scaffold that wraps all tab screens with a persistent
/// bottom navigation bar. Receives a [StatefulNavigationShell] from
/// GoRouter's StatefulShellRoute for proper tab state preservation.
class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: 'nav.portfolio'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up_outlined),
            activeIcon: const Icon(Icons.trending_up),
            label: 'nav.funds'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long),
            label: 'nav.transactions'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: 'nav.settings'.tr(),
          ),
        ],
      ),
    );
  }
}
