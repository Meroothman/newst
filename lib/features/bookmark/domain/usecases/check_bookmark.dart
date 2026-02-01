import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/bookmark_repository.dart';

class CheckBookmark {
  final BookmarkRepository repository;

  CheckBookmark(this.repository);

  Future<Either<Failure, bool>> call(String title) async {
    return await repository.isBookmarked(title);
  }
}