import 'package:btg_funds/preferences/infrastructure/app_preferences_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

/// Provides the [SharedPreferences] instance.
/// This provider MUST be overridden in the [ProviderScope] at app startup
/// with the pre-initialized SharedPreferences instance.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw StateError('sharedPreferencesProvider must be overridden');

/// Provides the [AppPreferencesRepository] backed by SharedPreferences.
@Riverpod(keepAlive: true)
AppPreferencesRepository appPreferencesRepository(Ref ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return AppPreferencesRepository(sharedPreferences: prefs);
}
