import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/api/model/NewsArticale.dart';
import 'package:news_app/api/model/Source_Response.dart';
import 'package:news_app/api/model/news.dart';

class CacheManager {
  static const String newsBoxName = "news_cache_box";
  static const String sourcesBoxName = "sources_cache_box";
  static const String favoritesBoxName = "favorites_cache_box";

  static late Box<String> _newsBox;
  static late Box<String> _sourcesBox;
  static late Box<String> _favoritesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _newsBox = await Hive.openBox<String>(newsBoxName);
    _sourcesBox = await Hive.openBox<String>(sourcesBoxName);
    _favoritesBox = await Hive.openBox<String>(favoritesBoxName);
  }

  // Save news JSON for a source
  static Future<void> saveNews(String sourceId, Map<String, dynamic> json) async {
    try {
      await _newsBox.put(sourceId, jsonEncode(json));
    } catch (_) {}
  }

  // Get cached news for a source
  static NewsArticale? getCachedNews(String sourceId) {
    try {
      final cachedString = _newsBox.get(sourceId);
      if (cachedString == null || cachedString.isEmpty) {
        return null;
      }
      final decoded = jsonDecode(cachedString);
      return NewsArticale.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  // Save sources JSON for a category
  static Future<void> saveSources(String categoryId, Map<String, dynamic> json) async {
    try {
      await _sourcesBox.put(categoryId, jsonEncode(json));
    } catch (_) {}
  }

  // Get cached sources for a category
  static SourceResponse? getCachedSources(String categoryId) {
    try {
      final cachedString = _sourcesBox.get(categoryId);
      if (cachedString == null || cachedString.isEmpty) {
        return null;
      }
      final decoded = jsonDecode(cachedString);
      return SourceResponse.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  // --- Favorites / Bookmarks Cache ---

  static String _getNewsKey(News news) {
    return news.url ?? news.title ?? news.publishedAt ?? news.hashCode.toString();
  }

  // Save a news article to favorites
  static Future<void> saveFavorite(News news) async {
    try {
      final key = _getNewsKey(news);
      if (key.isNotEmpty) {
        await _favoritesBox.put(key, jsonEncode(news.toJson()));
      }
    } catch (_) {}
  }

  // Remove a news article from favorites
  static Future<void> removeFavorite(News news) async {
    try {
      final key = _getNewsKey(news);
      if (key.isNotEmpty) {
        await _favoritesBox.delete(key);
      }
    } catch (_) {}
  }

  // Check if a news article is favorited
  static bool isFavorite(News news) {
    try {
      final key = _getNewsKey(news);
      return key.isNotEmpty && _favoritesBox.containsKey(key);
    } catch (_) {
      return false;
    }
  }

  // Retrieve all saved favorite news articles
  static List<News> getFavorites() {
    try {
      final List<News> list = [];
      for (final value in _favoritesBox.values) {
        if (value.isNotEmpty) {
          final decoded = jsonDecode(value);
          list.add(News.fromJson(decoded));
        }
      }
      return list.reversed.toList(); // Most recently added first
    } catch (_) {
      return [];
    }
  }
}
