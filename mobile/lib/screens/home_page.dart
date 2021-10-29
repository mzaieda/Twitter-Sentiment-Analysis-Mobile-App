import 'package:flutter/material.dart';
import 'package:mobile/components/query_input.dart';
import 'package:mobile/components/searches_list.dart';
import 'package:mobile/models/query.dart';
import 'package:mobile/models/searches.dart';
import 'package:localstorage/localstorage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _maxRecentQueries = 30;
  int _index = 0;
  final Searches _searches = Searches();
  final LocalStorage _storage = LocalStorage('Twitter_Sentiment_Analysis');

  @override
  void initState() {
    super.initState();
    _getFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Twitter Sentiment Analysis"),
      ),
      body: <Widget>[
        Column(
          children: [
            QueryInput(addToRecent: _addToRecent),
            const Text("Recent searches (swipe to remove)"),
            SearchesList(
              searches: _searches.recent,
              addToRecent: _addToRecent,
              removeFromRecent: _removeFromRecent,
              updateFavorites: _updateFavorite,
              favoritesOnly: false,
              key: const Key("all"),
            ),
          ],
        ),
        Column(
          children: [
            SearchesList(
              searches: _searches.favorites,
              addToRecent: _addToRecent,
              updateFavorites: _removeFromFavorite,
              favoritesOnly: true,
              key: const Key("favorites"),
            ),
          ],
        ),
      ][_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            _index = idx;
          });
        },
        currentIndex: _index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }

  void _addToRecent(String text) {
    setState(() {
      int recentIndex = _searches.findQueryInRecent(text);
      int favoritesIndex = _searches.findQueryInFavorites(text);
      bool favorite = (favoritesIndex == -1 ? false : true);

      if (recentIndex == -1) {
        // If the query is new add it to the queries list
        if (_searches.recent.length >= _maxRecentQueries) {
          _searches.recent.removeLast();
        }
        _searches.recent.insert(0, Query(text: text, favorite: favorite));
      } else {
        // Otherwise put the query on top of the others
        _searches.recent.insert(0, _searches.recent[recentIndex]);
        _searches.recent.removeAt(recentIndex + 1);
      }
    });

    _saveRecentToStorage();
  }

  void _addToFavorite(Query query) {
    _searches.favorites.add(Query(text: query.text, favorite: true));
    _saveFavoritesToStorage();
  }

  void _removeFromRecent(int index) {
    setState(() {
      _searches.recent.removeAt(index);
    });
    _saveRecentToStorage();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Removed from recent")));
  }

  void _removeFromFavorite(int index) {
    setState(() {
      Query query = _searches.favorites[index];
      int recentIndex = _searches.findQueryInRecent(query.text);

      if (recentIndex != -1) {
        // If the query is also in recent, update its state
        _searches.recent[recentIndex].favorite =
            !_searches.recent[recentIndex].favorite;
        _saveRecentToStorage();
      }

      _searches.favorites.removeAt(index);
      _saveFavoritesToStorage();
    });
  }

  void _updateFavorite(int index) {
    setState(() {
      Query query = _searches.recent[index];

      if (query.favorite) {
        // If the query was favorite, remove it from favorites list
        _searches.favorites
            .removeAt(_searches.findQueryInFavorites(query.text));
        _saveFavoritesToStorage();
      } else {
        // Otherwise add it to favorites list
        _addToFavorite(query);
      }

      // Change the favorites state of the Query
      _searches.recent[index].favorite = !_searches.recent[index].favorite;
      _saveRecentToStorage();
    });
  }

  void _saveRecentToStorage() {
    _storage.setItem('recent', _searches.recentToJsonEncodable());
  }

  void _saveFavoritesToStorage() {
    _storage.setItem('favorites', _searches.favoritesToJsonEncodable());
  }

  void _getFromStorage() async {
    List<dynamic> recent = [], favorites = [];

    await _storage.ready;
    recent = _storage.getItem('recent') ?? [];

    await _storage.ready;
    favorites = _storage.getItem('favorites') ?? [];

    setState(() {
      _searches.fromJson(recent: recent, favorites: favorites);
    });
  }
}
