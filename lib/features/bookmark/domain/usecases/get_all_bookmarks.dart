import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../news/domain/entities/news.dart';
import '../repositories/bookmark_repository.dart';

class GetAllBookmarks {
  final BookmarkRepository repository;

  GetAllBookmarks(this.repository);

  Future<Either<Failure, List<News>>> call() async {
    return await repository.getAllBookmarks();
  }
}