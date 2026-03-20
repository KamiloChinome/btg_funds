import 'package:btg_funds/app/router/app_router.dart';
import 'package:btg_funds/app/theme/app_theme.dart';
import 'package:btg_funds/preferences/application/app_preferences_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Root application widget.
/// Configures the MaterialApp with GoRouter, theme, localization,
/// and watches preferences for dynamic theme switching.
class BtgFundsApp extends ConsumerWidget {
  const BtgFundsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsState = ref.watch(appPreferencesNotifierProvider);
    final isDark = prefsState.appPreferences.isDarkTheme;

    return MaterialApp.router(
      title: 'appTitle'.tr(),
      debugShowCheckedModeBanner: false,
      theme: isDark ? buildDarkTheme() : buildAppTheme(),
      routerConfig: appRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
