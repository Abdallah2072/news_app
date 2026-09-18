import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/api/model/NewsArticale.dart';
import 'package:news_app/api/model/Source_Response.dart';

class CacheManager {
  static const String newsBoxName = "news_cache_box";
  static const String sourcesBoxName = "sources_cache_box";

  static late Box<String> _newsBox;
  static late Box<String> _sourcesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _newsBox = await Hive.openBox<String>(newsBoxName);
    _sourcesBox = await Hive.openBox<String>(sourcesBoxName);
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
}
