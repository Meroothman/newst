import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/news.dart';
import '../repositories/news_repository.dart';

class SearchNews {
  final NewsRepository repository;

  SearchNews(this.repository);

  Future<Either<Failure, List<News>>> call(SearchNewsParams params) async {
    return await repository.searchNews(
      query: params.query,
      language: params.language,
      country: params.country,
    );
  }
}

class SearchNewsParams extends Equatable {
  final String query;
  final String language;
  final String country;

  const SearchNewsParams({
    required this.query,
    required this.language,
    required this.country,
  });

  @override
  List<Object?> get props => [query, language, country];
}