import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/category_chips.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  ConsumerState<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends ConsumerState<NewsFeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(newsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);

    return Column(
      children: [
        const CategoryChips(),
        Expanded(child: _buildBody(newsState)),
      ],
    );
  }

  Widget _buildBody(NewsState state) {
    if (state.status == NewsStatus.loading ||
        state.status == NewsStatus.initial) {
      return const ArticleShimmerList();
    }

    if (state.status == NewsStatus.error && state.articles.isEmpty) {
      return ErrorDisplay(
        message: state.errorMessage ?? 'Failed to load news',
        onRetry: () => ref.read(newsProvider.notifier).refresh(),
      );
    }

    if (state.articles.isEmpty) {
      return const EmptyState(
        icon: Icons.article_outlined,
        title: 'No articles found',
        subtitle: 'Try a different category',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(newsProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.articles.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.articles.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
            );
          }
          return ArticleCard(article: state.articles[index]);
        },
      ),
    );
  }
}
