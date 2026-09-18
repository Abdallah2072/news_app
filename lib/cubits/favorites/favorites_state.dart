import 'package:news_app/api/model/news.dart';

abstract class FavoritesState {
  final List<News> favorites;
  const FavoritesState(this.favorites);
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial() : super(const []);
}

class FavoritesUpdated extends FavoritesState {
  const FavoritesUpdated(super.favorites);
}
