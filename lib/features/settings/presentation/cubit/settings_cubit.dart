import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit({required this.repository}) : super(SettingsInitial());

  String _currentLanguage = 'en';
  String _currentCountry = 'us';
  Map<String, String> _userInfo = {};

  String get currentLanguage => _currentLanguage;
  String get currentCountry => _currentCountry;
  Map<String, String> get userInfo => _userInfo;

  Future<void> loadSettings() async {
    emit(SettingsLoading());

    final languageResult = await repository.getLanguage();
    final countryResult = await repository.getCountry();
    final userInfoResult = await repository.getUserInfo();

    languageResult.fold(
      (failure) => null,
      (language) => _currentLanguage = language,
    );

    countryResult.fold(
      (failure) => null,
      (country) => _currentCountry = country,
    );

    userInfoResult.fold(
      (failure) => null,
      (info) => _userInfo = info,
    );

    emit(SettingsLoaded(
      language: _currentLanguage,
      country: _currentCountry,
      userInfo: _userInfo,
    ));
  }

  Future<void> changeLanguage(String language) async {
    final result = await repository.saveLanguage(language);
    
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) {
        _currentLanguage = language;
        emit(SettingsLoaded(
          language: _currentLanguage,
          country: _currentCountry,
          userInfo: _userInfo,
        ));
      },
    );
  }

  Future<void> changeCountry(String country) async {
    final result = await repository.saveCountry(country);
    
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) {
        _currentCountry = country;
        emit(SettingsLoaded(
          language: _currentLanguage,
          country: _currentCountry,
          userInfo: _userInfo,
        ));
      },
    );
  }

  Future<void> updateUserInfo({String? name, String? email, String? phone}) async {
    final result = await repository.saveUserInfo(
      name: name,
      email: email,
      phone: phone,
    );
    
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => loadSettings(),
    );
  }

  Future<void> completeOnboarding() async {
    await repository.setOnboardingComplete();
  }

  Future<bool> checkOnboardingStatus() async {
    final result = await repository.isOnboardingComplete();
    return result.fold(
      (failure) => false,
      (isComplete) => isComplete,
    );
  }
}