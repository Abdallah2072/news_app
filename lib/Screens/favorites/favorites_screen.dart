import 'package:flutter/material.dart';
import 'package:news_app/Providers/favorites_provider.dart';
import 'package:news_app/Widgets/news/news_Items.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.bookmarks,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_border_rounded,
                        size: 72,
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.no_bookmarks,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.no_bookmarks_desc,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final news = favorites[index];
                return NewsItems(news: news);
              },
            ),
    );
  }
}
