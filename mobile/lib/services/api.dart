import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/analysis.dart';
import 'package:http/http.dart' as http;

Future<Analysis> fetchApi(String query) async {
  String url = (dotenv.env['API_URL'] ?? '') + query;

  final response = await http.get(Uri.parse(url)).timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      throw (TimeoutException);
    },
  );

  return Analysis.fromJson(jsonDecode(response.body));
}
