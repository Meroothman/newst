import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveLanguage(String language);
  Future<String> getLanguage();
  Future<void> saveCountry(String country);
  Future<String> getCountry();
  Future<void> saveUserInfo({String? name, String? email, String? phone});
  Future<Map<String, String>> getUserInfo();
  Future<void> setOnboardingComplete();
  Future<bool> isOnboardingComplete();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveLanguage(String language) async {
    try {
      await sharedPreferences.setString(
        AppConstants.keySelectedLanguage,
        language,
      );
    } catch (e) {
      throw CacheException('Failed to save language');
    }
  }

  @override
  Future<String> getLanguage() async {
    try {
      return sharedPreferences.getString(AppConstants.keySelectedLanguage) ??
          AppConstants.defaultLanguage;
    } catch (e) {
      throw CacheException('Failed to get language');
    }
  }

  @override
  Future<void> saveCountry(String country) async {
    try {
      await sharedPreferences.setString(
        AppConstants.keySelectedCountry,
        country,
      );
    } catch (e) {
      throw CacheException('Failed to save country');
    }
  }

  @override
  Future<String> getCountry() async {
    try {
      return sharedPreferences.getString(AppConstants.keySelectedCountry) ??
          AppConstants.defaultCountry;
    } catch (e) {
      throw CacheException('Failed to get country');
    }
  }

  @override
  Future<void> saveUserInfo({String? name, String? email, String? phone}) async {
    try {
      if (name != null) {
        await sharedPreferences.setString(AppConstants.keyUserName, name);
      }
      if (email != null) {
        await sharedPreferences.setString(AppConstants.keyUserEmail, email);
      }
      if (phone != null) {
        await sharedPreferences.setString(AppConstants.keyUserPhone, phone);
      }
    } catch (e) {
      throw CacheException('Failed to save user info');
    }
  }

  @override
  Future<Map<String, String>> getUserInfo() async {
    try {
      return {
        'name': sharedPreferences.getString(AppConstants.keyUserName) ?? '',
        'email': sharedPreferences.getString(AppConstants.keyUserEmail) ?? '',
        'phone': sharedPreferences.getString(AppConstants.keyUserPhone) ?? '',
      };
    } catch (e) {
      throw CacheException('Failed to get user info');
    }
  }

  @override
  Future<void> setOnboardingComplete() async {
    try {
      await sharedPreferences.setBool(
        AppConstants.keyOnboardingComplete,
        true,
      );
    } catch (e) {
      throw CacheException('Failed to set onboarding complete');
    }
  }

  @override
  Future<bool> isOnboardingComplete() async {
    try {
      return sharedPreferences.getBool(AppConstants.keyOnboardingComplete) ?? false;
    } catch (e) {
      return false;
    }
  }
}