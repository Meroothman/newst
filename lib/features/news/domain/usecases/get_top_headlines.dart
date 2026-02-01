import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  Future<Either<Failure, List<News>>> call(GetTopHeadlinesParams params) async {
    return await repository.getTopHeadlines(
      category: params.category,
      language: params.language,
      country: params.country,
    );
  }
}

class GetTopHeadlinesParams extends Equatable {
  final String category;
  final String language;
  final String country;

  const GetTopHeadlinesParams({
    required this.category,
    required this.language,
    required this.country,
  });

  @override
  List<Object?> get props => [category, language, country];
}