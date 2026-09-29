import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/providers.dart';
import '../../../news/domain/entities/article.dart';

enum FavoritesStatus { initial, loading, success, error }

class FavoritesState {
  final FavoritesStatus status;
  final List<Article> articles;
  final Set<String> favoriteIds;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.articles = const [],
    this.favoriteIds = const {},
    this.errorMessage,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Article>? articles,
    Set<String>? favoriteIds,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage: errorMessage,
    );
  }

  bool isFavorite(String id) => favoriteIds.contains(id);
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final Ref _ref;

  FavoritesNotifier(this._ref) : super(const FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(status: FavoritesStatus.loading);
    final result = await _ref.read(favoritesRepositoryProvider).getFavorites();

    if (result.failure != null) {
      state = state.copyWith(status: FavoritesStatus.error, errorMessage: result.failure!.message);
    } else {
      state = state.copyWith(
        status: FavoritesStatus.success,
        articles: result.articles,
        favoriteIds: result.articles.map((a) => a.id).toSet(),
        errorMessage: null,
      );
    }
  }

  Future<void> toggleFavorite(Article article) async {
    final repo = _ref.read(favoritesRepositoryProvider);
    final isFav = state.isFavorite(article.id);

    if (isFav) {
      final result = await repo.removeFavorite(article.id);
      if (result.success) {
        state = state.copyWith(
          favoriteIds: Set<String>.from(state.favoriteIds)..remove(article.id),
          articles: state.articles.where((a) => a.id != article.id).toList(),
        );
      }
    } else {
      final result = await repo.addFavorite(article);
      if (result.success) {
        state = state.copyWith(
          favoriteIds: Set<String>.from(state.favoriteIds)..add(article.id),
          articles: [article, ...state.articles],
        );
      }
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(ref);
});