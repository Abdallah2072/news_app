import 'package:flutter/material.dart';
import 'package:news_app/Screens/category_details/category_Details.dart';
import 'package:news_app/Widgets/categories/categories_widget.dart';
import 'package:news_app/Widgets/home_drawer.dart';
import 'package:news_app/Widgets/news/news_search_delegate.dart';
import 'package:news_app/api/model/category_model.dart';
import 'package:news_app/core/App_Routes.dart';
import 'package:news_app/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryModel? selectedCategory;

  void onCategoryClick(CategoryModel category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void onGoToHome() {
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: selectedCategory == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && selectedCategory != null) {
          setState(() {
            selectedCategory = null;
          });
        }
      },
      child: Scaffold(
        drawer: HomeDrawer(onGoToHome: onGoToHome),
        appBar: AppBar(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_outline_rounded, size: 30),
              tooltip: l10n.bookmarks,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.favoritesRouteName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.search_outlined, size: 32),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: NewsSearchDelegate(),
                );
              },
            ),
          ],
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, size: 32),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text(
            selectedCategory == null ? l10n.home : selectedCategory!.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body: selectedCategory == null
            ? CategoriesWidget(onCategoryClick: onCategoryClick)
            : CategoryDetails(category: selectedCategory!),
      ),
    );
  }
}
