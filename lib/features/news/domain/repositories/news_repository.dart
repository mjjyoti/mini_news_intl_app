import '../../../../core/errors/failures.dart';
import '../entities/article.dart';

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
