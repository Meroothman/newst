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
          'max': 10, // Limit results for better performance
        },
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException('No data received from server');
        }
        
        final List articles = response.data['articles'] ?? [];
        
        if (articles.isEmpty) {
          return []; // Return empty list, let repository handle it
        }
        
        return articles
            .map((article) {
              try {
                return NewsModel.fromJson(article);
              } catch (e) {
                // Skip malformed articles
                return null;
              }
            })
            .where((model) => model != null)
            .cast<NewsModel>()
            .toList();
      } else if (response.statusCode == 401) {
        throw ServerException('Invalid API key. Please check your configuration.');
      } else if (response.statusCode == 429) {
        throw ServerException('Too many requests. Please try again later.');
      } else {
        throw ServerException('Failed to load news. Server returned status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Server took too long to respond. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('Unable to connect to server. Please check your internet connection.');
      } else if (e.response?.statusCode == 401) {
        throw ServerException('Invalid API key. Please check your configuration.');
      } else if (e.response?.statusCode == 429) {
        throw ServerException('Too many requests. Please try again later.');
      } else {
        throw ServerException(e.message ?? 'Network error occurred. Please try again.');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
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
          'max': 20, // More results for search
        },
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException('No data received from server');
        }
        
        final List articles = response.data['articles'] ?? [];
        
        return articles
            .map((article) {
              try {
                return NewsModel.fromJson(article);
              } catch (e) {
                // Skip malformed articles
                return null;
              }
            })
            .where((model) => model != null)
            .cast<NewsModel>()
            .toList();
      } else if (response.statusCode == 401) {
        throw ServerException('Invalid API key. Please check your configuration.');
      } else if (response.statusCode == 429) {
        throw ServerException('Too many requests. Please try again later.');
      } else {
        throw ServerException('Failed to search news. Server returned status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Server took too long to respond. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('Unable to connect to server. Please check your internet connection.');
      } else if (e.response?.statusCode == 401) {
        throw ServerException('Invalid API key. Please check your configuration.');
      } else if (e.response?.statusCode == 429) {
        throw ServerException('Too many requests. Please try again later.');
      } else {
        throw ServerException(e.message ?? 'Network error occurred. Please try again.');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}