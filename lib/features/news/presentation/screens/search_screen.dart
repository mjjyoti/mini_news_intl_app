import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/search_provider.dart';
import '../widgets/article_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchProvider.notifier).loadMore();
    }
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search articles...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  ref.read(searchProvider.notifier).clear();
                  setState(() {});
                },
              )
                  : null,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (q) => ref.read(searchProvider.notifier).search(q),
          ),
        ),
        Expanded(child: _buildBody(searchState)),
      ],
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.status == SearchStatus.initial) {
      return const EmptyState(
        icon: Icons.search,
        title: 'Search for news',
        subtitle: 'Find articles on any topic',
      );
    }

    if (state.status == SearchStatus.loading) {
      return const ArticleShimmerList();
    }

    if (state.status == SearchStatus.error && state.articles.isEmpty) {
      return ErrorDisplay(
        message: state.errorMessage ?? 'Search failed',
        onRetry: () => ref.read(searchProvider.notifier).search(state.query),
      );
    }

    if (state.articles.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No results for "${state.query}"',
        subtitle: 'Try different keywords',
      );
    }

    return ListView.builder(
      controller: _scrollController,
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
    );
  }
}