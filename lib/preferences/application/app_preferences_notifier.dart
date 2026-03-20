import 'package:btg_funds/preferences/application/app_preferences_state.dart';
import 'package:btg_funds/preferences/domain/app_preferences.dart';
import 'package:btg_funds/preferences/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_preferences_notifier.g.dart';

/// Notifier that manages the user's application preferences.
/// Loads preferences from SharedPreferences on initialization and
/// provides methods to update individual preference values.
///
/// Marked [keepAlive] to persist across the entire app lifecycle.
@Riverpod(keepAlive: true)
class AppPreferencesNotifier extends _$AppPreferencesNotifier {
  @override
  AppPreferencesState build() {
    final repository = ref.read(appPreferencesRepositoryProvider);

    // Load all preferences synchronously from SharedPreferences
    final isDarkTheme = repository.getIsDarkTheme().fold(
          (_) => false,
          (value) => value,
        );
    final languageCode = repository.getLanguageCode().fold(
          (_) => 'en',
          (value) => value,
        );

    final preferences = AppPreferences(
      isDarkTheme: isDarkTheme,
      languageCode: languageCode,
    );

    return AppPreferencesState.data(preferences);
  }

  /// Updates the dark theme preference.
  Future<void> setIsDarkTheme(bool isDarkTheme) async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final result = await repository.setIsDarkTheme(isDarkTheme);

    result.fold(
      (_) => state = AppPreferencesState.failure(state.appPreferences),
      (_) => state = AppPreferencesState.data(
        state.appPreferences.copyWith(isDarkTheme: isDarkTheme),
      ),
    );
  }

  /// Updates the language code preference.
  Future<void> setLanguageCode(String languageCode) async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final result = await repository.setLanguageCode(languageCode);

    result.fold(
      (_) => state = AppPreferencesState.failure(state.appPreferences),
      (_) => state = AppPreferencesState.data(
        state.appPreferences.copyWith(languageCode: languageCode),
      ),
    );
  }
}
