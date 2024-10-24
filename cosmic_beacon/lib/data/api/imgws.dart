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
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<Uri?> getRedirectUrl(String url) async {
    http.Request req =
        http.Request("Get", Uri.https(url.split('/')[0], url.split('/')[1]))
          ..followRedirects = false;
    http.Client baseClient = http.Client();
    http.StreamedResponse response = await baseClient.send(req);
    Uri? redirectUri = response.headers['location'] != null
        ? Uri.parse(response.headers['location']!)
        : null;

    return redirectUri;
  }
}

final imageApiProvider = Provider<ImageApi>((ref) => ImageApi());
