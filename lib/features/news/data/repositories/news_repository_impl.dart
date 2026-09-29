import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<({List<Article> articles, Failure? failure})> getTopHeadlines({
    required String category,
    int page = 1,
  }) async {
    try {
      final articles = await remoteDataSource.getTopHeadlines(category: category, page: page);
      return (articles: articles, failure: null);
    } on ServerException catch (e) {
      return (articles: <Article>[], failure: ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return (articles: <Article>[], failure: NetworkFailure(e.message));
    } catch (e) {
      return (articles: <Article>[], failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({List<Article> articles, Failure? failure})> searchArticles({
    required String query,
    int page = 1,
  }) async {
    try {
      final articles = await remoteDataSource.searchArticles(query: query, page: page);
      return (articles: articles, failure: null);
    } on ServerException catch (e) {
      return (articles: <Article>[], failure: ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return (articles: <Article>[], failure: NetworkFailure(e.message));
    } catch (e) {
      return (articles: <Article>[], failure: UnknownFailure(e.toString()));
    }
  }
}