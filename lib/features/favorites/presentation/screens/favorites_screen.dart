import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../news/presentation/widgets/article_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favState = ref.watch(favoritesProvider);

    if (favState.status == FavoritesStatus.loading ||
        favState.status == FavoritesStatus.initial) {
      return const LoadingWidget(message: 'Loading favorites...');
    }

    if (favState.status == FavoritesStatus.error) {
      return ErrorDisplay(
        message: favState.errorMessage ?? 'Failed to load favorites',
        onRetry: () => ref.read(favoritesProvider.notifier).loadFavorites(),
      );
    }

    if (favState.articles.isEmpty) {
      return const EmptyState(
        icon: Icons.bookmark_border,
        title: 'No favorites yet',
        subtitle: 'Bookmark articles to save them offline',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(favoritesProvider.notifier).loadFavorites(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: favState.articles.length,
        itemBuilder: (context, index) =>
            ArticleCard(article: favState.articles[index]),
      ),
    );
  }
}
