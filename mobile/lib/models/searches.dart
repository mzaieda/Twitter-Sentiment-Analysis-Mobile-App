import 'package:mobile/models/query.dart';

class Searches {
  List<Query> recent = [];
  List<Query> favorites = [];

  recentToJsonEncodable() =>
      recent.map((query) => query.toJsonEncodable()).toList();

  favoritesToJsonEncodable() =>
      favorites.map((query) => query.toJsonEncodable()).toList();

  void fromJson(List<dynamic> recent, List<dynamic> favorites) {
    this.recent = recent.map((json) => Query.fromJson(json)).toList();
    this.favorites = favorites.map((json) => Query.fromJson(json)).toList();
  }
}
