import 'package:flutter/material.dart';
import 'package:news_app/api/model/category_model.dart';
import 'package:news_app/core/App_Colors.dart';
import 'package:news_app/l10n/app_localizations.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEven = index % 2 == 0;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 190,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.WhiteColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0F000000),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // 1. Graphic
              _buildGraphic(isEven),

              // 2. Title Text
              _buildTitle(context, isEven),

              // 3. View All Pill Button
              Align(
                alignment: isEven ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildViewAllButton(context, isEven),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphic(bool isEven) {
    if (category.id == 'general' ||
        category.id == 'business' ||
        category.id == 'sports') {
      return SizedBox.expand(
        child: Image.asset(
          category.image,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return SizedBox.expand(
        child: Align(
          alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: 0.55,
            heightFactor: 0.95,
            child: Image.asset(
              category.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildTitle(BuildContext context, bool isEven) {
    return Align(
      alignment: isEven ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Text(
          category.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFF171717),
          ),
        ),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context, bool isEven) {
    final viewAllText = AppLocalizations.of(context)!.view_All;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xD96B6B6B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isEven
            ? [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Text(
                    viewAllText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF171717),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ]
            : [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF171717),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 12),
                  child: Text(
                    viewAllText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
