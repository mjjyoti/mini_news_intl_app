import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../news/data/models/article_model.dart';
import '../../../news/domain/entities/article.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<({List<Article> articles, Failure? failure})> getFavorites() async {
    try {
      final articles = await localDataSource.getFavorites();
      return (articles: articles, failure: null);
    } on CacheException catch (e) {
      return (articles: <Article>[], failure: CacheFailure(e.message));
    } catch (e) {
      return (articles: <Article>[], failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({bool success, Failure? failure})> addFavorite(
    Article article,
  ) async {
    try {
      await localDataSource.addFavorite(ArticleModel.fromEntity(article));
      return (success: true, failure: null);
    } on CacheException catch (e) {
      return (success: false, failure: CacheFailure(e.message));
    } catch (e) {
      return (success: false, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({bool success, Failure? failure})> removeFavorite(
    String articleId,
  ) async {
    try {
      await localDataSource.removeFavorite(articleId);
      return (success: true, failure: null);
    } on CacheException catch (e) {
      return (success: false, failure: CacheFailure(e.message));
    } catch (e) {
      return (success: false, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> isFavorite(String articleId) =>
      localDataSource.isFavorite(articleId);
}
