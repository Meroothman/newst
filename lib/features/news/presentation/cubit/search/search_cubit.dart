import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/news.dart';
import '../../../domain/usecases/search_news.dart';


part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchNews searchNews;
  String selectedLanguage;
  String selectedCountry;

  SearchCubit({
    required this.searchNews,
    required this.selectedLanguage,
    required this.selectedCountry,
  }) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final params = SearchNewsParams(
      query: query,
      language: selectedLanguage,
      country: selectedCountry,
    );

    final result = await searchNews(params);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (news) => emit(SearchLoaded(news)),
    );
  }

  void updateSettings({String? language, String? country}) {
    if (language != null) selectedLanguage = language;
    if (country != null) selectedCountry = country;
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}