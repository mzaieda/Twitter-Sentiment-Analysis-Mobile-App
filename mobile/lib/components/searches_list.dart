import 'package:flutter/material.dart';
import 'package:mobile/models/query.dart';
import 'package:mobile/screens/loading_page.dart';

class SearchesList extends StatefulWidget {
  final List<Query> searches;
  final bool favoritesOnly;

  const SearchesList(this.searches, this.favoritesOnly, {Key? key})
      : super(key: key);

  @override
  _SearchesListState createState() => _SearchesListState();
}

class _SearchesListState extends State<SearchesList> {
  Widget _displayCard(int index) {
    return Card(
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
          setState(() {}); // TODO
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
                  setState(() {}); // TODO
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
