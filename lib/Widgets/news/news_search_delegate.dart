import 'package:flutter/material.dart';
import 'package:news_app/Widgets/main_Error_Widget.dart';
import 'package:news_app/Widgets/main_LoadingWidget.dart';
import 'package:news_app/Widgets/news/news_Items.dart';
import 'package:news_app/api/api_Manager.dart';
import 'package:news_app/api/model/NewsArticale.dart';
import 'package:news_app/core/App_Size.dart';
import 'package:news_app/l10n/app_localizations.dart';

class NewsSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return theme.copyWith(
      scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: isDark ? Colors.white60 : Colors.black45,
          fontSize: 18,
        ),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          if (query.trim().isNotEmpty) {
            showResults(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 70,
              color: Theme.of(context).splashColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.search,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder<NewsArticale>(
      future: ApiManager.getNewsBySearch(query.trim()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MainLoadingwidget();
        } else if (snapshot.hasError) {
          return MainErrorWidget(
            errorMessage: snapshot.error?.toString() ?? "Something went wrong",
            onPressed: () {
              showResults(context);
            },
          );
        } else if (snapshot.data?.status != "ok") {
          return MainErrorWidget(
            errorMessage: snapshot.data?.message ?? "Error fetching news",
            onPressed: () {
              showResults(context);
            },
          );
        } else {
          final newsList = snapshot.data?.articles ?? [];
          if (newsList.isEmpty) {
            return Center(
              child: Text(
                "No News Item Founded",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: newsList.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: context.height * 0.02),
            itemBuilder: (context, index) {
              return NewsItems(news: newsList[index]);
            },
          );
        }
      },
    );
  }
}
