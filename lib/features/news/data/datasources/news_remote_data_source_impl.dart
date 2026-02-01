import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/news_model.dart';
import 'news_remote_data_source.dart';

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NewsModel>> getTopHeadlines({
    required String category,
    required String language,
    required String country,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.topHeadlines}',
        queryParameters: {
          'category': category,
          'lang': language,
          'country': country,
          'apikey': ApiConstants.apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List articles = response.data['articles'] ?? [];
        return articles.map((article) => NewsModel.fromJson(article)).toList();
      } else {
        throw ServerException('Failed to load news');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<List<NewsModel>> searchNews({
    required String query,
    required String language,
    required String country,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.search}',
        queryParameters: {
          'q': query,
          'lang': language,
          'country': country,
          'apikey': ApiConstants.apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List articles = response.data['articles'] ?? [];
        return articles.map((article) => NewsModel.fromJson(article)).toList();
      } else {
        throw ServerException('Failed to search news');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('Unexpected error occurred');
    }
  }
}