import 'package:flutter/material.dart';
import 'package:news_app/api/model/news.dart';
import 'package:news_app/core/cache/cache_manager.dart';

class FavoritesProvider extends ChangeNotifier {
  List<News> _favorites = [];

  FavoritesProvider() {
    _loadFavorites();
  }

  List<News> get favorites => _favorites;

  void _loadFavorites() {
    _favorites = CacheManager.getFavorites();
    notifyListeners();
  }

  bool isFavorite(News news) {
    return CacheManager.isFavorite(news);
  }

  /// Returns true if newly added, false if removed
  Future<bool> toggleFavorite(News news) async {
    final alreadyFavorited = CacheManager.isFavorite(news);
    if (alreadyFavorited) {
      await CacheManager.removeFavorite(news);
      _favorites.removeWhere(
        (item) =>
            (item.url != null && item.url == news.url) ||
            (item.title != null && item.title == news.title),
      );
      notifyListeners();
      return false;
    } else {
      await CacheManager.saveFavorite(news);
      _favorites.removeWhere(
        (item) =>
            (item.url != null && item.url == news.url) ||
            (item.title != null && item.title == news.title),
      );
      _favorites.insert(0, news);
      notifyListeners();
      return true;
    }
  }

  Future<void> removeFavorite(News news) async {
    await CacheManager.removeFavorite(news);
    _favorites.removeWhere(
      (item) =>
          (item.url != null && item.url == news.url) ||
          (item.title != null && item.title == news.title),
    );
    notifyListeners();
  }
}
