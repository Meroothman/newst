import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<News>>> getTopHeadlines({
    required String category,
    required String language,
    required String country,
  }) async {
    // Check network connectivity first
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return const Left(NetworkFailure('No internet connection. Please check your network settings.'));
    }

    try {
      final newsModels = await remoteDataSource.getTopHeadlines(
        category: category,
        language: language,
        country: country,
      );
      
      // Check if we got empty results
      if (newsModels.isEmpty) {
        return const Left(ServerFailure('No news available for this category at the moment.'));
      }
      
      return Right(newsModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load news. Please try again later.'));
    }
  }

  @override
  Future<Either<Failure, List<News>>> searchNews({
    required String query,
    required String language,
    required String country,
  }) async {
    // Check network connectivity first
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return const Left(NetworkFailure('No internet connection. Please check your network settings.'));
    }

    try {
      final newsModels = await remoteDataSource.searchNews(
        query: query,
        language: language,
        country: country,
      );
      return Right(newsModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to search news. Please try again later.'));
    }
  }
}