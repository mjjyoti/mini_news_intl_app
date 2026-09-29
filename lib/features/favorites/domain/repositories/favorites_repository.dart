import '../../../news/domain/entities/article.dart';
import '../../../../core/errors/failures.dart';

abstract class FavoritesRepository {
  Future<({List<Article> articles, Failure? failure})> getFavorites();
  Future<({bool success, Failure? failure})> addFavorite(Article article);
  Future<({bool success, Failure? failure})> removeFavorite(String articleId);
  Future<bool> isFavorite(String articleId);
}