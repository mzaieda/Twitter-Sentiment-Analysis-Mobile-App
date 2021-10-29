import 'package:mobile/models/query.dart';

class Searches {
  List<Query> recent = [];
  List<Query> favorites = [];

  int _findQueryInList(List<Query> list, String text) {
    for (int i = 0; i < list.length; ++i) {
      if (list[i].text == text) {
        return i;
      }
    }
    return -1;
  }

  int findQueryInRecent(String text) {
    return _findQueryInList(recent, text);
  }

  int findQueryInFavorites(String text) {
    return _findQueryInList(favorites, text);
  }

  recentToJsonEncodable() =>
      recent.map((query) => query.toJsonEncodable()).toList();

  favoritesToJsonEncodable() =>
      favorites.map((query) => query.toJsonEncodable()).toList();

  void fromJson(
      {required List<dynamic> recent, required List<dynamic> favorites}) {
    this.recent = recent.map((json) => Query.fromJson(json)).toList();
    this.favorites = favorites.map((json) => Query.fromJson(json)).toList();
  }
}
