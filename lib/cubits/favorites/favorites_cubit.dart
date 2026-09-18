import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/model/news.dart';
import 'package:news_app/core/cache/cache_manager.dart';
import 'package:news_app/cubits/favorites/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesInitial()) {
    loadFavorites();
  }

  void loadFavorites() {
    final list = CacheManager.getFavorites();
    emit(FavoritesUpdated(list));
  }

  bool isFavorite(News news) {
    return CacheManager.isFavorite(news);
  }

  /// Returns true if added, false if removed
  Future<bool> toggleFavorite(News news) async {
    final alreadyFav = CacheManager.isFavorite(news);
    final currentList = List<News>.from(state.favorites);

    if (alreadyFav) {
      await CacheManager.removeFavorite(news);
      currentList.removeWhere((item) =>
          (item.url != null && item.url == news.url) ||
          (item.title != null && item.title == news.title));
      emit(FavoritesUpdated(currentList));
      return false;
    } else {
      await CacheManager.saveFavorite(news);
      currentList.removeWhere((item) =>
          (item.url != null && item.url == news.url) ||
          (item.title != null && item.title == news.title));
      currentList.insert(0, news);
      emit(FavoritesUpdated(currentList));
      return true;
    }
  }

  Future<void> removeFavorite(News news) async {
    await CacheManager.removeFavorite(news);
    final currentList = List<News>.from(state.favorites);
    currentList.removeWhere((item) =>
        (item.url != null && item.url == news.url) ||
        (item.title != null && item.title == news.title));
    emit(FavoritesUpdated(currentList));
  }
}
