import 'dart:convert';
import 'package:cosmic_beacon/models/api_key_singleton.dart';
import 'package:cosmic_beacon/models/url_singleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ImageApi {
  static String imgAPIUrl = UrlSingleton().imgAPIUrl;

  getImage() async {
    final response =
        await http.get(Uri.parse('$imgAPIUrl/?api_key=${ApiKey().apiKey}'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load image');
    }
  }
}

final imageApiProvider = Provider<ImageApi>((ref) => ImageApi());
