import 'dart:convert';
import 'package:cosmic_beacon/models/api_key_singleton.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/equatable_list.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeoApi {
  static const String neoAPIUrl = 'https://api.nasa.gov/neo/rest/v1';

  Future<List<AsteroidData>> getNEO(DateTime dateTime) async {
    final formattedDate =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final urlWithDate =
        '$neoAPIUrl/feed?start_date=$formattedDate&end_date=$formattedDate&api_key=${ApiKey().apiKey}';

    // Check if data exists in shared preferences
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(formattedDate);

    if (cachedData != null) {
      print(cachedData);
      final Map<String, dynamic> json = jsonDecode(cachedData);
      return _parseNEOData(json);
    } else {
      final response = await http.get(Uri.parse(urlWithDate));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        await prefs.setString(formattedDate, response.body);

        return _parseNEOData(json);
      } else {
        throw Exception('Failed to fetch NEO data');
      }
    }
  }

  Future<AsteroidData> getNeoById(String id) async {
    final url = '$neoAPIUrl/neo/$id?api_key=${ApiKey().apiKey}';

    // Check if data exists in shared preferences
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(id);

    if (cachedData != null) {
      final Map<String, dynamic> json = jsonDecode(cachedData);
      return AsteroidData.fromJson(json);
    } else {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        await prefs.setString(id, response.body);

        return AsteroidData.fromJson(json);
      } else {
        throw Exception('Failed to fetch NEO data for ID: $id');
      }
    }
  }

  Future<List<AsteroidData>> getMultipleNeoById(EquatableList ids) async {
    List<AsteroidData> neoList = [];
    List<String> neos = ids.list.cast<String>();

    final prefs = await SharedPreferences.getInstance();

    await Future.wait(neos.map((id) async {
      final cachedData = prefs.getString(id);

      if (cachedData != null) {
        final Map<String, dynamic> json = jsonDecode(cachedData);
        neoList.add(AsteroidData.fromJson(json));
      } else {
        final url = '$neoAPIUrl/neo/$id?api_key=${ApiKey().apiKey}';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final Map<String, dynamic> json = jsonDecode(response.body);
          neoList.add(AsteroidData.fromJson(json));

          // Save the response to shared preferences
          await prefs.setString(id, response.body);
        } else {
          throw Exception('Failed to fetch NEO data for ID: $id');
        }
      }
    }));

    return neoList;
  }

  List<AsteroidData> _parseNEOData(Map<String, dynamic> json) {
    final Map<String, dynamic> neoMap = json['near_earth_objects'];
    List<AsteroidData> neoList = [];
    neoMap.entries.forEach((entry) {
      final List<dynamic> neoData = entry.value;
      for (var i = 0; i < neoData.length; i++) {
        neoList.add(AsteroidData.fromJson(neoData[i]));
      }
    });
    return neoList;
  }
}

final neoProvider = Provider<NeoApi>((ref) => NeoApi());
