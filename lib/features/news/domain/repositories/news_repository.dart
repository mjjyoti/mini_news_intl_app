import '../entities/article.dart';
import '../../../../core/errors/failures.dart';

abstract class NewsRepository {
  Future<({List<Article> articles, Failure? failure})> getTopHeadlines({
    required String category,
    int page = 1,
  });

  Future<({List<Article> articles, Failure? failure})> searchArticles({
    required String query,
    int page = 1,
  });
}