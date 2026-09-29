import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    required String category,
    int page = 1,
  });

  Future<List<ArticleModel>> searchArticles({
    required String query,
    int page = 1,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient apiClient;

  NewsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    required String category,
    int page = 1,
  }) async {
    final response = await apiClient.get(
      ApiConstants.topHeadlines,
      queryParams: {
        'category': category,
        'country': ApiConstants.defaultCountry,
        'page': page.toString(),
        'pageSize': ApiConstants.pageSize.toString(),
      },
    );

    final articles = response['articles'] as List<dynamic>? ?? [];
    return articles
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .where((a) => a.title.isNotEmpty && a.title != '[Removed]')
        .toList();
  }

  @override
  Future<List<ArticleModel>> searchArticles({
    required String query,
    int page = 1,
  }) async {
    if (query.trim().isEmpty) {
      throw const ServerException(message: 'Search query cannot be empty');
    }

    final response = await apiClient.get(
      ApiConstants.everything,
      queryParams: {
        'q': query.trim(),
        'language': 'en',
        'sortBy': 'publishedAt',
        'page': page.toString(),
        'pageSize': ApiConstants.pageSize.toString(),
      },
    );

    final articles = response['articles'] as List<dynamic>? ?? [];
    return articles
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .where((a) => a.title.isNotEmpty && a.title != '[Removed]')
        .toList();
  }
}
