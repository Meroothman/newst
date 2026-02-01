import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../news/domain/entities/news.dart';
import '../repositories/bookmark_repository.dart';

class ToggleBookmark {
  final BookmarkRepository repository;

  ToggleBookmark(this.repository);

  Future<Either<Failure, void>> call(News news) async {
    final isBookmarkedResult = await repository.isBookmarked(news.title);
    
    return isBookmarkedResult.fold(
      (failure) => Left(failure),
      (isBookmarked) async {
        if (isBookmarked) {
          return await repository.removeBookmark(news.title);
        } else {
          return await repository.addBookmark(news);
        }
      },
    );
  }
}