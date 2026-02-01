import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveLanguage(String language) async {
    try {
      await localDataSource.saveLanguage(language);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getLanguage() async {
    try {
      final language = await localDataSource.getLanguage();
      return Right(language);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveCountry(String country) async {
    try {
      await localDataSource.saveCountry(country);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getCountry() async {
    try {
      final country = await localDataSource.getCountry();
      return Right(country);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserInfo({
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      await localDataSource.saveUserInfo(name: name, email: email, phone: phone);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getUserInfo() async {
    try {
      final userInfo = await localDataSource.getUserInfo();
      return Right(userInfo);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setOnboardingComplete() async {
    try {
      await localDataSource.setOnboardingComplete();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async {
    try {
      final isComplete = await localDataSource.isOnboardingComplete();
      return Right(isComplete);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}