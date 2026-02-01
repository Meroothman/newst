import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../news/domain/entities/news.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, void>> addBookmark(News news);
  Future<Either<Failure, void>> removeBookmark(String title);
  Future<Either<Failure, List<News>>> getAllBookmarks();
  Future<Either<Failure, bool>> isBookmarked(String title);
}