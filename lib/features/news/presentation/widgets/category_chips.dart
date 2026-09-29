import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/news_provider.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(newsProvider.select((s) => s.category));

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: ApiConstants.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ApiConstants.categories[index];
          final isSelected = category == selectedCategory;

          return FilterChip(
            label: Text(
              category[0].toUpperCase() + category.substring(1),
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => ref.read(newsProvider.notifier).changeCategory(category),
            selectedColor: AppTheme.primaryColor,
            backgroundColor: Colors.white,
            checkmarkColor: Colors.white,
            side: BorderSide(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}