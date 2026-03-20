import 'package:btg_funds/core/domain/failure.dart';
import 'package:btg_funds/preferences/domain/app_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository that manages reading and writing user preferences
/// to the device's SharedPreferences storage.
class AppPreferencesRepository {
  const AppPreferencesRepository({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  // ---------------------------------------------------------------------------
  // isDarkTheme
  // ---------------------------------------------------------------------------

  /// Reads the dark theme preference. Returns [false] if not set.
  Either<Failure, bool> getIsDarkTheme() {
    try {
      final value = sharedPreferences.getBool(
        AppPreferencesKeys.isDarkTheme.name,
      );
      return right(value ?? false);
    } catch (e, st) {
      return left(Failure.unexpected(
        message: 'failure.savingPreference'.tr(),
        cause: e,
        stackTrace: st,
      ));
    }
  }

  /// Persists the dark theme preference.
  Future<Either<Failure, Unit>> setIsDarkTheme(bool isDarkTheme) async {
    try {
      await sharedPreferences.setBool(
        AppPreferencesKeys.isDarkTheme.name,
        isDarkTheme,
      );
      return right(unit);
    } catch (e, st) {
      return left(Failure.unexpected(
        message: 'failure.savingPreference'.tr(),
        cause: e,
        stackTrace: st,
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // languageCode
  // ---------------------------------------------------------------------------

  /// Reads the saved language code. Returns ['en'] if not set.
  Either<Failure, String> getLanguageCode() {
    try {
      final value = sharedPreferences.getString(
        AppPreferencesKeys.languageCode.name,
      );
      return right(value ?? 'en');
    } catch (e, st) {
      return left(Failure.unexpected(
        message: 'failure.savingPreference'.tr(),
        cause: e,
        stackTrace: st,
      ));
    }
  }

  /// Persists the language code preference.
  Future<Either<Failure, Unit>> setLanguageCode(String languageCode) async {
    try {
      await sharedPreferences.setString(
        AppPreferencesKeys.languageCode.name,
        languageCode,
      );
      return right(unit);
    } catch (e, st) {
      return left(Failure.unexpected(
        message: 'failure.savingPreference'.tr(),
        cause: e,
        stackTrace: st,
      ));
    }
  }
}
