import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newst/features/news/presentation/cubit/news/news_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/api_constants.dart';
import 'core/constants/app_constants.dart';
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
import 'features/news/presentation/cubit/search/search_cubit.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - News
  // Cubit
  sl.registerFactory(
    () => NewsCubit(
      getTopHeadlines: sl(),
    ),
  );

  sl.registerFactory(
    () => SearchCubit(
      searchNews: sl(),
      selectedLanguage: sl<SettingsCubit>().currentLanguage,
      selectedCountry: sl<SettingsCubit>().currentCountry,
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => SearchNews(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(dio: sl()),
  );

  // ! Features - Bookmark
  // Cubit
  sl.registerFactory(
    () => BookmarkCubit(
      getAllBookmarks: sl(),
      toggleBookmark: sl(),
      checkBookmark: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllBookmarks(sl()));
  sl.registerLazySingleton(() => ToggleBookmark(sl()));
  sl.registerLazySingleton(() => CheckBookmark(sl()));

  // Repository
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<BookmarkLocalDataSource>(
    () => BookmarkLocalDataSourceImpl(box: sl()),
  );

  // ! Features - Settings
  // Cubit
  sl.registerLazySingleton(
    () => SettingsCubit(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // ! Core
  // Dio
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    ),
  );

  // ! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final bookmarksBox = await Hive.openBox<NewsModel>(AppConstants.bookmarksBox);
  sl.registerLazySingleton(() => bookmarksBox);
}