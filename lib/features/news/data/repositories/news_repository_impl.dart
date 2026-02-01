import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<News>>> getTopHeadlines({
    required String category,
    required String language,
    required String country,
  }) async {
    try {
      final newsModels = await remoteDataSource.getTopHeadlines(
        category: category,
        language: language,
        country: country,
      );
      return Right(newsModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<News>>> searchNews({
    required String query,
    required String language,
    required String country,
  }) async {
    try {
      final newsModels = await remoteDataSource.searchNews(
        query: query,
        language: language,
        country: country,
      );
      return Right(newsModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }
}