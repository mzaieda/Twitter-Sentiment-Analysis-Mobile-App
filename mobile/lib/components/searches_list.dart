import 'package:flutter/material.dart';
import 'package:mobile/models/query.dart';
import 'package:mobile/screens/loading_page.dart';

class SearchesList extends StatefulWidget {
  final List<Query> searches;
  final Function addToRecent;
  final Function removeFromRecent;
  final Function updateFavorites;
  final bool favoritesOnly;

  const SearchesList(this.searches, this.addToRecent, this.removeFromRecent,
      this.updateFavorites, this.favoritesOnly,
      {Key? key})
      : super(key: key);

  @override
  _SearchesListState createState() => _SearchesListState();
}

class _SearchesListState extends State<SearchesList> {
  Widget _displayCard(int index) {
    Widget queryCard = Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 10,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.addToRecent(widget.searches[index].text);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoadingPage(widget.searches[index].text),
            ),
          );
        },
        child: Container(
          height: 80,
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.searches[index].text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.updateFavorites(index);
                  });
                },
                icon: Icon(
                  widget.searches[index].favorite
                      ? Icons.star
                      : Icons.star_border,
                  size: 20,
                  color: widget.searches[index].favorite
                      ? Colors.yellow
                      : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );

    if (widget.favoritesOnly) {
      return queryCard;
    } else {
      return Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        key: Key(widget.searches[index].text),
        onDismissed: (direction) {
          widget.removeFromRecent(index);
        },
        child: queryCard,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.searches.length,
        itemBuilder: (BuildContext context, int index) => _displayCard(index),
      ),
    );
  }
}
