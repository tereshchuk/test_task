import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'Test.dart';

Future<List<Test>> fetchPhotos(http.Client client, int page) async {
  final response = await client.get(Uri.parse(
      'https://api.unsplash.com/photos/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0&page=$page'));

  return compute(parsePhotos, response.body);
}

List<Test> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Test>((json) => Test.fromJson(json)).toList();
}
