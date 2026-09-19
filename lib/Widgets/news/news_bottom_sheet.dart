import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/model/news.dart';
import 'package:news_app/core/App_Routes.dart';
import 'package:news_app/cubits/favorites/favorites_cubit.dart';
import 'package:news_app/cubits/favorites/favorites_state.dart';
import 'package:news_app/cubits/theme/theme_cubit.dart';
import 'package:news_app/l10n/app_localizations.dart';

class NewsBottomSheet extends StatelessWidget {
  final News news;

  const NewsBottomSheet({super.key, required this.news});

  void _openArticle(BuildContext context) {
    final urlString = news.url;
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No URL available for this article")),
      );
      return;
    }

    Navigator.pop(context); // Close the bottom sheet
    Navigator.pushNamed(
      context,
      AppRoutes.articleWebViewRouteName,
      arguments: news,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.watch<ThemeCubit>().isDarkMode() ||
        Theme.of(context).brightness == Brightness.dark;

    final sheetBg = isDark ? Colors.white : Colors.black;
    final textColor = isDark ? Colors.black : Colors.white;
    final buttonBg = isDark ? Colors.black : Colors.white;
    final buttonText = isDark ? Colors.white : Colors.black;

    final articleText = (news.content != null && news.content!.trim().isNotEmpty)
        ? news.content!
        : (news.description ?? "");

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (news.urlToImage != null && news.urlToImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    news.urlToImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              const SizedBox(height: 14),
              Text(
                articleText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBg,
                          foregroundColor: buttonText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => _openArticle(context),
                        child: Text(
                          l10n.view_Full_Articel,
                          style: TextStyle(
                            color: buttonText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final isFav = state.favorites.any((item) =>
                          (item.url != null && item.url == news.url) ||
                          (item.title != null && item.title == news.title));
                      return Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: buttonBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.bookmark : Icons.bookmark_border_rounded,
                            color: isFav ? Colors.amber : buttonText,
                            size: 26,
                          ),
                          onPressed: () async {
                            final added = await context.read<FavoritesCubit>().toggleFavorite(news);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Text(
                                    added
                                        ? l10n.added_to_bookmarks
                                        : l10n.removed_from_bookmarks,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
