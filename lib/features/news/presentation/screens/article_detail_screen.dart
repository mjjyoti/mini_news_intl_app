import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/entities/article.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider.select((s) => s.isFavorite(article.id)));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: article.imageUrl != null ? 250 : 0,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFavorite ? 'Removed from favorites' : 'Saved to favorites'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: article.imageUrl != null
                ? FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: article.imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppTheme.primaryColor),
              ),
            )
                : null,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName != null)
                    Chip(
                      label: Text(article.sourceName!, style: const TextStyle(fontSize: 12)),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.6),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                    ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (article.author != null) ...[
                        Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            article.author!,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        AppDateUtils.formatFull(article.publishedAt),
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: const TextStyle(fontSize: 16, height: 1.6, color: AppTheme.textPrimary),
                    ),
                  if (article.content != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      article.content!.replaceAll(RegExp(r'\[\+\d+ chars\]'), ''),
                      style: const TextStyle(fontSize: 15, height: 1.6, color: AppTheme.textSecondary),
                    ),
                  ],
                  if (article.url != null) ...[
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _openUrl(article.url),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Read Full Article'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppTheme.primaryColor),
                          foregroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}