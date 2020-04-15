import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:modernui/examples/deezer/models/track.dart';

class DeezerAPI {
  //https://api.deezer.com/search/?q=imagine%20dragons
  static final host = 'https://api.deezer.com';

  static Future<List<DeezerTrack>> search(String query) async {
    try {
      final url = '$host/search?q=${Uri.encodeFull(query)}';
      print(url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final tracks = (parsed['data'] as List)
            .map<DeezerTrack>((item) => DeezerTrack.fromJson(item))
            .toList();

        return tracks;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
