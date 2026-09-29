import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../news/data/models/article_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<ArticleModel>> getFavorites();
  Future<void> addFavorite(ArticleModel article);
  Future<void> removeFavorite(String articleId);
  Future<bool> isFavorite(String articleId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  Box get _box => Hive.box(AppConstants.hiveFavoritesBox);

  @override
  Future<List<ArticleModel>> getFavorites() async {
    try {
      final values = _box.values.toList();
      return values
          .map((e) => ArticleModel.fromHiveMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList()
        ..sort((a, b) {
          final aDate = a.publishedAt ?? DateTime(1970);
          final bDate = b.publishedAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
    } catch (e) {
      throw CacheException(message: 'Failed to load favorites: $e');
    }
  }

  @override
  Future<void> addFavorite(ArticleModel article) async {
    try {
      await _box.put(article.id, article.toHiveMap());
    } catch (e) {
      throw CacheException(message: 'Failed to save favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String articleId) async {
    try {
      await _box.delete(articleId);
    } catch (e) {
      throw CacheException(message: 'Failed to remove favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(String articleId) async {
    try {
      return _box.containsKey(articleId);
    } catch (_) {
      return false;
    }
  }
}