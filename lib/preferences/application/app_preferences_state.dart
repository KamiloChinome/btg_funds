import 'package:btg_funds/preferences/domain/app_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_preferences_state.freezed.dart';

/// State for the preferences notifier.
/// All variants carry the current [AppPreferences] so the UI
/// always has access to preference values, even during loading or failure.
@freezed
sealed class AppPreferencesState with _$AppPreferencesState {
  const AppPreferencesState._();

  const factory AppPreferencesState.loading(
    AppPreferences appPreferences,
  ) = AppPreferencesLoading;

  const factory AppPreferencesState.data(
    AppPreferences appPreferences,
  ) = AppPreferencesData;

  const factory AppPreferencesState.failure(
    AppPreferences appPreferences,
  ) = AppPreferencesFailure;
}
