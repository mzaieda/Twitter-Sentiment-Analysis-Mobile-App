import 'package:flutter/material.dart';
import 'package:mobile/components/query_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Twitter Sentiment Analyzer'),
      ),
      body: Column(
        children: const <Widget>[
          QueryInput(),
          Text("TODO"), // TODO
        ],
      ),
    );
  }
}
