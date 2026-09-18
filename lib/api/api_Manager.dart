import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/api/api_Constant.dart';
import 'package:news_app/api/end_Points.dart';
import 'package:news_app/api/model/NewsArticale.dart';
import 'package:news_app/api/model/Source_Response.dart';
import 'package:news_app/core/cache/cache_manager.dart';

class ApiManager {
  ///https://newsapi.org/v2/top-headlines/sources?apiKey=8638535545634efeb22c5bbeef3fc575
  static Future<SourceResponse> getSources(String categoryId) async {
    try {
      Uri url = Uri.https(ApiConstant.baseUrl,
          EndPoints.SourceApi,
          {
            "apiKey": ApiConstant.ApiKey,
            "category": categoryId,
          }
      );
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      final sourceResponse = SourceResponse.fromJson(json);
      if (sourceResponse.status == "ok") {
        CacheManager.saveSources(categoryId, json);
      }
      return sourceResponse;
    } catch (e) {
      final cached = CacheManager.getCachedSources(categoryId);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

 ///https://newsapi.org/v2/everything?q=bitcoin&apiKey=8638535545634efeb22c5bbeef3fc575
  static Future<NewsArticale> getNewsBySourceId(
    String sourceId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      Uri url = Uri.https(
        ApiConstant.baseUrl,
        EndPoints.NewsApi,
        {
          "apiKey": ApiConstant.ApiKey,
          "sources": sourceId,
          "page": "$page",
          "pageSize": "$pageSize",
        },
      );
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      final newsArticle = NewsArticale.fromJson(json);
      if (newsArticle.status == "ok" && page == 1) {
        CacheManager.saveNews(sourceId, json);
      }
      return newsArticle;
    } catch (e) {
      final cached = CacheManager.getCachedNews(sourceId);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  static Future<NewsArticale> getNewsBySearch(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    if (query.trim().isEmpty) {
      return NewsArticale(status: "ok", totalResults: 0, articles: []);
    }
    try {
      Uri url = Uri.https(
        ApiConstant.baseUrl,
        EndPoints.NewsApi,
        {
          "apiKey": ApiConstant.ApiKey,
          "q": query,
          "page": "$page",
          "pageSize": "$pageSize",
        },
      );
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return NewsArticale.fromJson(json);
    } catch (e) {
      rethrow;
    }
  }
}