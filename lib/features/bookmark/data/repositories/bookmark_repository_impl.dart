import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../news/data/models/news_model.dart';
import '../../../news/domain/entities/news.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_data_source.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addBookmark(News news) async {
    try {
      final newsModel = NewsModel(
        title: news.title,
        content: news.content,
        description: news.description,
        image: news.image,
        sourceName: news.sourceName,
        publishedAt: news.publishedAt,
      );
      await localDataSource.addBookmark(newsModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String title) async {
    try {
      await localDataSource.removeBookmark(title);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<News>>> getAllBookmarks() async {
    try {
      final bookmarks = await localDataSource.getAllBookmarks();
      return Right(bookmarks.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(String title) async {
    try {
      final isBookmarked = await localDataSource.isBookmarked(title);
      return Right(isBookmarked);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}