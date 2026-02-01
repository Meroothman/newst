import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/news.dart';
import '../../../domain/usecases/get_top_headlines.dart';


part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetTopHeadlines getTopHeadlines;

  NewsCubit({
    required this.getTopHeadlines,
  }) : super(NewsInitial());

  String selectedCategory = AppConstants.categories[0];
  String selectedLanguage = AppConstants.defaultLanguage;
  String selectedCountry = AppConstants.defaultCountry;

  Future<void> fetchNews({
    String? category,
    String? language,
    String? country,
  }) async {
    emit(NewsLoading());

    if (category != null) selectedCategory = category;
    if (language != null) selectedLanguage = language;
    if (country != null) selectedCountry = country;

    final params = GetTopHeadlinesParams(
      category: selectedCategory,
      language: selectedLanguage,
      country: selectedCountry,
    );

    final result = await getTopHeadlines(params);

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (news) => emit(NewsLoaded(news)),
    );
  }

  void changeCategory(String category) {
    selectedCategory = category;
    fetchNews(category: category);
  }

  void updateSettings({String? language, String? country}) {
    if (language != null) selectedLanguage = language;
    if (country != null) selectedCountry = country;
    fetchNews();
  }
}