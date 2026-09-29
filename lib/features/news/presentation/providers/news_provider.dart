import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/providers.dart';
import '../../domain/entities/article.dart';

enum NewsStatus { initial, loading, loadingMore, success, error }

class NewsState {
  final NewsStatus status;
  final List<Article> articles;
  final String category;
  final int page;
  final bool hasMore;
  final String? errorMessage;

  const NewsState({
    this.status = NewsStatus.initial,
    this.articles = const [],
    this.category = 'business',
    this.page = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<Article>? articles,
    String? category,
    int? page,
    bool? hasMore,
    String? errorMessage,
  }) {
    return NewsState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      category: category ?? this.category,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  final Ref _ref;

  NewsNotifier(this._ref) : super(const NewsState()) {
    loadArticles();
  }

  Future<void> loadArticles({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(status: NewsStatus.loading, page: 1, articles: [], hasMore: true, errorMessage: null);
    } else if (state.status == NewsStatus.initial) {
      state = state.copyWith(status: NewsStatus.loading);
    }

    final result = await _ref.read(newsRepositoryProvider).getTopHeadlines(
      category: state.category,
      page: state.page,
    );

    if (result.failure != null) {
      state = state.copyWith(status: NewsStatus.error, errorMessage: result.failure!.message);
    } else {
      final newArticles = result.articles;
      state = state.copyWith(
        status: NewsStatus.success,
        articles: refresh ? newArticles : [...state.articles, ...newArticles],
        hasMore: newArticles.length >= 20,
        errorMessage: null,
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == NewsStatus.loadingMore) return;

    state = state.copyWith(status: NewsStatus.loadingMore, page: state.page + 1);

    final result = await _ref.read(newsRepositoryProvider).getTopHeadlines(
      category: state.category,
      page: state.page,
    );

    if (result.failure != null) {
      state = state.copyWith(status: NewsStatus.success, page: state.page - 1, errorMessage: result.failure!.message);
    } else {
      final newArticles = result.articles;
      state = state.copyWith(
        status: NewsStatus.success,
        articles: [...state.articles, ...newArticles],
        hasMore: newArticles.length >= 20,
      );
    }
  }

  Future<void> changeCategory(String category) async {
    if (category == state.category) return;
    state = state.copyWith(
      category: category,
      page: 1,
      articles: [],
      hasMore: true,
      status: NewsStatus.loading,
      errorMessage: null,
    );
    await loadArticles(refresh: true);
  }

  Future<void> refresh() => loadArticles(refresh: true);
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  return NewsNotifier(ref);
});