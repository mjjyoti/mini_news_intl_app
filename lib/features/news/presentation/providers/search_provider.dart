import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/providers.dart';
import '../../domain/entities/article.dart';

enum SearchStatus { initial, loading, loadingMore, success, error }

class SearchState {
  final SearchStatus status;
  final List<Article> articles;
  final String query;
  final int page;
  final bool hasMore;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.articles = const [],
    this.query = '',
    this.page = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Article>? articles,
    String? query,
    int? page,
    bool? hasMore,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      query: query ?? this.query,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref _ref;

  SearchNotifier(this._ref) : super(const SearchState());

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(
      status: SearchStatus.loading,
      query: trimmed,
      page: 1,
      articles: [],
      hasMore: true,
      errorMessage: null,
    );

    final result = await _ref
        .read(newsRepositoryProvider)
        .searchArticles(query: trimmed, page: 1);

    if (result.failure != null) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: result.failure!.message,
      );
    } else {
      state = state.copyWith(
        status: SearchStatus.success,
        articles: result.articles,
        hasMore: result.articles.length >= 20,
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.status == SearchStatus.loadingMore ||
        state.query.isEmpty)
      return;

    state = state.copyWith(
      status: SearchStatus.loadingMore,
      page: state.page + 1,
    );

    final result = await _ref
        .read(newsRepositoryProvider)
        .searchArticles(query: state.query, page: state.page);

    if (result.failure != null) {
      state = state.copyWith(
        status: SearchStatus.success,
        page: state.page - 1,
      );
    } else {
      state = state.copyWith(
        status: SearchStatus.success,
        articles: [...state.articles, ...result.articles],
        hasMore: result.articles.length >= 20,
      );
    }
  }

  void clear() => state = const SearchState();
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier(ref);
});
