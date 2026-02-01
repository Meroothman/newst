import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../news/data/models/news_model.dart';

abstract class BookmarkLocalDataSource {
  Future<void> addBookmark(NewsModel news);
  Future<void> removeBookmark(String title);
  Future<List<NewsModel>> getAllBookmarks();
  Future<bool> isBookmarked(String title);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  final Box<NewsModel> box;

  BookmarkLocalDataSourceImpl({required this.box});

  @override
  Future<void> addBookmark(NewsModel news) async {
    try {
      await box.put(news.title, news);
    } catch (e) {
      throw CacheException('Failed to add bookmark');
    }
  }

  @override
  Future<void> removeBookmark(String title) async {
    try {
      await box.delete(title);
    } catch (e) {
      throw CacheException('Failed to remove bookmark');
    }
  }

  @override
  Future<List<NewsModel>> getAllBookmarks() async {
    try {
      return box.values.toList();
    } catch (e) {
      throw CacheException('Failed to get bookmarks');
    }
  }

  @override
  Future<bool> isBookmarked(String title) async {
    try {
      return box.containsKey(title);
    } catch (e) {
      return false;
    }
  }
}