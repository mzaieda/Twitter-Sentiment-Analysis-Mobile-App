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
  int _index = 0;
  final Searches _searches = Searches();
  final LocalStorage _recentStorage = LocalStorage('recent');
  final LocalStorage _favoritesStorage = LocalStorage('favorites');

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
            QueryInput(_addToRecent),
            const Text("Recent queries (swipe to remove)"),
            SearchesList(
              _searches.recent,
              _addToRecent,
              _removeFromRecent,
              _updateFavorite,
              false,
              key: const Key("all"),
            ),
          ],
        ),
        Column(
          children: [
            SearchesList(
              _searches.favorites,
              _addToRecent,
              () {},
              _removeFavorite,
              true,
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
      int index = -1;

      // Check if the query was already been searched
      for (int i = 0; i < _searches.recent.length; ++i) {
        if (_searches.recent[i].text == text) {
          index = i;
          break;
        }
      }

      if (index == -1) {
        // If the query is new add it to the queries list
        if (_searches.recent.length >= 30) {
          _searches.recent.removeLast();
        }
        _searches.recent.insert(0, Query(text: text, favorite: false));
      } else {
        // Otherwise put the query on top of the others
        _searches.recent.insert(0, _searches.recent[index]);
        _searches.recent.removeAt(index + 1);
      }
    });

    _saveToStorage('recent');
  }

  void _addToFavorite(Query query) {
    _searches.favorites.add(Query(text: query.text, favorite: true));
    _saveToStorage('favorites');
  }

  void _removeFromRecent(int index) {
    setState(() {
      _searches.recent.removeAt(index);
      _saveToStorage('recent');
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("query removed")));
  }

  void _updateFavorite(int index) {
    setState(() {
      Query query = _searches.recent[index];

      if (query.favorite) {
        // If the query was favorite, remove it from favorites list
        for (int i = 0; i < _searches.favorites.length; ++i) {
          if (_searches.favorites[i].text == query.text &&
              _searches.favorites[i].favorite == query.favorite) {
            _searches.favorites.removeAt(i);
            _saveToStorage('favorites');
            break;
          }
        }
      } else {
        // Otherwise add it to favorites list
        _addToFavorite(query);
      }

      // Change the favorites state of the Query
      _searches.recent[index].favorite = !_searches.recent[index].favorite;
      _saveToStorage('recent');
    });
  }

  void _removeFavorite(int index) {
    setState(() {
      Query query = _searches.favorites[index];

      // If the query is also in recent, update its state
      for (int i = 0; i < _searches.recent.length; ++i) {
        if (_searches.recent[i].text == query.text &&
            _searches.recent[i].favorite == query.favorite) {
          _searches.recent[i].favorite = !_searches.recent[i].favorite;
          _saveToStorage('recent');
          break;
        }
      }

      _searches.favorites.removeAt(index);
      _saveToStorage('favorites');
    });
  }

  void _saveToStorage(String type) {
    if (type == 'recent') {
      _recentStorage.setItem(type, _searches.recentToJsonEncodable());
    } else if (type == 'favorites') {
      _favoritesStorage.setItem(type, _searches.favoritesToJsonEncodable());
    }
  }

  void _getFromStorage() async {
    await _recentStorage.ready;
    await _favoritesStorage.ready;
    setState(() {
      List<dynamic> recent = _recentStorage.getItem('recent') ?? [];
      List<dynamic> favorites = _favoritesStorage.getItem('favorites') ?? [];
      _searches.fromJson(recent, favorites);
    });
  }
}
