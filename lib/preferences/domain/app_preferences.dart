import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_preferences.freezed.dart';

/// Keys for all stored preferences in SharedPreferences.
enum AppPreferencesKeys {
  isDarkTheme,
  languageCode,
}

/// Domain model representing the user's application preferences.
/// All fields have sensible defaults for first-launch experience.
@freezed
sealed class AppPreferences with _$AppPreferences {
  const AppPreferences._();

  const factory AppPreferences({
    @Default(false) bool isDarkTheme,
    @Default('en') String languageCode,
  }) = _AppPreferences;
}
