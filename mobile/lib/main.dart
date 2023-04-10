import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 186, 255, 188), // sets the primary color for the theme
      ),
      debugShowCheckedModeBanner: false,
      title: 'Twitter Sentiment Analyzer',
      home: const HomePage(),
    );
  }
}
