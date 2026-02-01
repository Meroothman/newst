part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String language;
  final String country;
  final Map<String, String> userInfo;

  const SettingsLoaded({
    required this.language,
    required this.country,
    required this.userInfo,
  });

  @override
  List<Object> get props => [language, country, userInfo];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}