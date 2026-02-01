import '../models/news_model.dart';

abstract class NewsRemoteDataSource {
  /// Calls the https://gnews.io/api/v4/top-headlines endpoint
  /// 
  /// Throws a [ServerException] for all error codes
  Future<List<NewsModel>> getTopHeadlines({
    required String category,
    required String language,
    required String country,
  });

  /// Calls the https://gnews.io/api/v4/search endpoint
  /// 
  /// Throws a [ServerException] for all error codes
  Future<List<NewsModel>> searchNews({
    required String query,
    required String language,
    required String country,
  });
}