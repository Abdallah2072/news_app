import 'package:flutter/material.dart';
import 'package:news_app/Widgets/categories/category_card.dart';
import 'package:news_app/api/model/category_model.dart';
import 'package:news_app/l10n/app_localizations.dart';

class CategoriesWidget extends StatelessWidget {
  final void Function(CategoryModel category) onCategoryClick;

  const CategoriesWidget({
    super.key,
    required this.onCategoryClick,
  });

  @override
  Widget build(BuildContext context) {
    final categories = CategoryModel.getCategories(context);

    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            AppLocalizations.of(context)!.good_Morning,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
          ),
        ),
        ...categories.asMap().entries.map((entry) {
          final int index = entry.key;
          final CategoryModel category = entry.value;
          return CategoryCard(
            category: category,
            index: index,
            onTap: () => onCategoryClick(category),
          );
        }),
      ],
    );
  }
}
