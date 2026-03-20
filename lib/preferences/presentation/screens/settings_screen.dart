import 'package:btg_funds/app/theme/app_colors.dart';
import 'package:btg_funds/preferences/application/app_preferences_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Settings screen allowing the user to toggle dark mode
/// and switch between English and Spanish.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsState = ref.watch(appPreferencesNotifierProvider);
    final prefs = prefsState.appPreferences;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ---- Appearance Section ----
          _SectionHeader(title: 'settings.appearance'.tr()),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              secondary: Icon(
                prefs.isDarkTheme
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
              title: Text('settings.darkMode'.tr()),
              subtitle: Text('settings.darkModeSubtitle'.tr()),
              value: prefs.isDarkTheme,
              onChanged: (value) {
                ref
                    .read(appPreferencesNotifierProvider.notifier)
                    .setIsDarkTheme(value);
              },
            ),
          ),

          const SizedBox(height: 16),

          // ---- Language Section ----
          _SectionHeader(title: 'settings.language'.tr()),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings.languageSubtitle'.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'en',
                          label: Text('English'),
                          icon: Icon(Icons.language),
                        ),
                        ButtonSegment(
                          value: 'es',
                          label: Text('Español'),
                          icon: Icon(Icons.language),
                        ),
                      ],
                      selected: {prefs.languageCode},
                      onSelectionChanged: (selection) =>
                          _changeLanguage(context, ref, selection.first),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---- About Section ----
          _SectionHeader(title: 'settings.about'.tr()),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
              ),
              title: Text('settings.appDescription'.tr()),
              subtitle: Text(
                'settings.version'.tr(namedArgs: {'version': '1.0.0'}),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Changes the app language by updating both EasyLocalization
  /// and the preferences notifier for persistence.
  void _changeLanguage(BuildContext context, WidgetRef ref, String code) {
    context.setLocale(Locale(code));
    ref.read(appPreferencesNotifierProvider.notifier).setLanguageCode(code);
  }
}

/// Section header widget for grouping settings categories.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
