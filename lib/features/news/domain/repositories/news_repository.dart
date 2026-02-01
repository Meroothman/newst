import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<News>>> getTopHeadlines({
    required String category,
    required String language,
    required String country,
  });

  Future<Either<Failure, List<News>>> searchNews({
    required String query,
    required String language,
    required String country,
  });
}