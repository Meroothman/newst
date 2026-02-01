import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../news/domain/entities/news.dart';
import '../../domain/usecases/check_bookmark.dart';
import '../../domain/usecases/get_all_bookmarks.dart';
import '../../domain/usecases/toggle_bookmark.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final GetAllBookmarks getAllBookmarks;
  final ToggleBookmark toggleBookmark;
  final CheckBookmark checkBookmark;

  BookmarkCubit({
    required this.getAllBookmarks,
    required this.toggleBookmark,
    required this.checkBookmark,
  }) : super(BookmarkInitial());

  Future<void> loadBookmarks() async {
    emit(BookmarkLoading());
    
    final result = await getAllBookmarks();
    
    result.fold(
      (failure) => emit(BookmarkError(failure.message)),
      (bookmarks) => emit(BookmarkLoaded(bookmarks)),
    );
  }

  Future<void> toggle(News news) async {
    final result = await toggleBookmark(news);
    
    result.fold(
      (failure) => emit(BookmarkError(failure.message)),
      (_) => loadBookmarks(),
    );
  }

  Future<bool> isBookmarked(String title) async {
    final result = await checkBookmark(title);
    return result.fold(
      (failure) => false,
      (isBookmarked) => isBookmarked,
    );
  }
}