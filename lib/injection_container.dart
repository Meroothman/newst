import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/api_constants.dart';
import 'core/constants/app_constants.dart';
import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'features/bookmark/domain/repositories/bookmark_repository.dart';
import 'features/bookmark/domain/usecases/check_bookmark.dart';
import 'features/bookmark/domain/usecases/get_all_bookmarks.dart';
import 'features/bookmark/domain/usecases/toggle_bookmark.dart';
import 'features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'features/news/data/datasources/news_remote_data_source.dart';
import 'features/news/data/datasources/news_remote_data_source_impl.dart';
import 'features/news/data/models/news_model.dart';
import 'features/news/data/repositories/news_repository_impl.dart';
import 'features/news/domain/repositories/news_repository.dart';
import 'features/news/domain/usecases/get_top_headlines.dart';
import 'features/news/domain/usecases/search_news.dart';
import 'features/news/presentation/cubit/news/news_cubit.dart';
import 'features/news/presentation/cubit/search/search_cubit.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Core - Must be initialized first
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final bookmarksBox = await Hive.openBox<NewsModel>(AppConstants.bookmarksBox);
  sl.registerLazySingleton(() => bookmarksBox);

  // Network
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Dio with improved configuration
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        validateStatus: (status) {
          // Accept any status code to handle it ourselves
          return status != null && status < 500;
        },
      ),
    )..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) {
            // Only log in debug mode
            // print(obj);
          },
        ),
      ),
  );

  // ! Features - Settings (Must be initialized before others that depend on it)
  // Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Cubit - Singleton to maintain state across app
  sl.registerLazySingleton(
    () => SettingsCubit(
      repository: sl(),
    ),
  );

  // ! Features - News
  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => SearchNews(sl()));

  // Cubits - Factories for new instances
  sl.registerFactory(
    () => NewsCubit(
      getTopHeadlines: sl(),
    ),
  );

  sl.registerFactory(
    () {
      final settingsCubit = sl<SettingsCubit>();
      final state = settingsCubit.state;
      
      String language = AppConstants.defaultLanguage;
      String country = AppConstants.defaultCountry;
      
      if (state is SettingsLoaded) {
        language = state.language;
        country = state.country;
      }
      
      return SearchCubit(
        searchNews: sl(),
        selectedLanguage: language,
        selectedCountry: country,
      );
    },
  );

  // ! Features - Bookmark
  // Data sources
  sl.registerLazySingleton<BookmarkLocalDataSource>(
    () => BookmarkLocalDataSourceImpl(box: sl()),
  );

  // Repository
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllBookmarks(sl()));
  sl.registerLazySingleton(() => ToggleBookmark(sl()));
  sl.registerLazySingleton(() => CheckBookmark(sl()));

  // Cubit
  sl.registerFactory(
    () => BookmarkCubit(
      getAllBookmarks: sl(),
      toggleBookmark: sl(),
      checkBookmark: sl(),
    ),
  );
}