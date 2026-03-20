import 'package:btg_funds/app/presentation/app_widget.dart';
import 'package:btg_funds/preferences/shared/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();

  // Read persisted language to set as start locale
  final savedLanguage = sharedPrefs.getString('languageCode') ?? 'en';

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        fallbackLocale: const Locale('en'),
        startLocale: Locale(savedLanguage),
        path: 'assets/lang',
        useOnlyLangCode: true,
        child: const BtgFundsApp(),
      ),
    ),
  );
}
