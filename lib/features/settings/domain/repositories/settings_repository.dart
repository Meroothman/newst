import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, void>> saveLanguage(String language);
  Future<Either<Failure, String>> getLanguage();
  Future<Either<Failure, void>> saveCountry(String country);
  Future<Either<Failure, String>> getCountry();
  Future<Either<Failure, void>> saveUserInfo({String? name, String? email, String? phone});
  Future<Either<Failure, Map<String, String>>> getUserInfo();
  Future<Either<Failure, void>> setOnboardingComplete();
  Future<Either<Failure, bool>> isOnboardingComplete();
}