import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Providers/favorites_provider.dart';
import 'package:news_app/Widgets/news/news_bottom_sheet.dart';
import 'package:news_app/api/model/news.dart';
import 'package:news_app/core/App_Size.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewsItems extends StatelessWidget {
  final News news;
  const NewsItems({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    final l10n = AppLocalizations.of(context);

    DateTime? parsedDate;
    if (news.publishedAt != null && news.publishedAt!.isNotEmpty) {
      parsedDate = DateTime.tryParse(news.publishedAt!);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => NewsBottomSheet(news: news),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.015,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.04,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).splashColor,
            width: 2,
          ),
        ),
        child: Column(
          spacing: height * 0.02,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (news.urlToImage != null && news.urlToImage!.isNotEmpty)
                      ? Image.network(
                          news.urlToImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      final isFav = favoritesProvider.isFavorite(news);
                      return Material(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () async {
                            final added = await favoritesProvider.toggleFavorite(news);
                            if (context.mounted && l10n != null) {
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              isFav ? Icons.bookmark : Icons.bookmark_border_rounded,
                              color: isFav ? Colors.amber : Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          Text(news.title ?? "" ,
          style: Theme.of(context).textTheme.bodyMedium,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("By : ${news.author}",
                  style: Theme.of(context).textTheme.titleMedium,),
              ),
              Text(
                parsedDate != null
                    ? DateFormat("dd/MM/yyyy").format(parsedDate)
                    : "",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )
        ],
      ),
    ),
    );
  }
}
