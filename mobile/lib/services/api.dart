import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/analysis.dart';
import 'package:http/http.dart' as http;

Future<Analysis> fetchApi(String query) async {
  final String url = 'http://10.0.2.2:8000/api/$query';

  final response = await http.get(Uri.parse(url)).timeout(
    const Duration(seconds: 8),
    onTimeout: () {
      throw (TimeoutException);
    },
  );

  return Analysis.fromJson(jsonDecode(response.body));
}
