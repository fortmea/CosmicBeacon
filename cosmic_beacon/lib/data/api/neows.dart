import 'dart:convert';
import 'package:cosmic_beacon/data/constants/strings.dart';
import 'package:cosmic_beacon/models/api_key_singleton.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/equatable_list.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

class NeoApi {
  Future<List<AsteroidData>> getNEO(DateTime dateTime) async {
    final formattedDate =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final urlWithDate =
        '$neoAPIUrl/feed?start_date=$formattedDate&end_date=$formattedDate&api_key=${ApiKey().apiKey}';
    final response = await http.get(
      Uri.parse(urlWithDate),
    );
    final Map<String, dynamic> json = jsonDecode(response.body);
    if (json.isNotEmpty) {
      final Map<String, dynamic> neoMap = json['near_earth_objects'];

      List<AsteroidData> neoList = [];
      neoMap.entries.forEach((entry) {
        final List<dynamic> neoData = entry.value;
        print(neoData[0]);
        for (var i = 0; i < neoData.length; i++) {
          neoList.add(AsteroidData.fromJson(neoData[i]));
        }
      });

      return neoList;
    }
    return [];
  }

  Future<AsteroidData> getNeoById(String id) async {
    final url = '$neoAPIUrl/neo/$id?api_key=${ApiKey().apiKey}';
    final response = await http.get(
      Uri.parse(url),
    );
    final Map<String, dynamic> json = jsonDecode(response.body);
    return AsteroidData.fromJson(json);
  }

  Future<List<AsteroidData>> getMultipleNeoById(EquatableList ids) async {
    List<AsteroidData> neoList = [];
    List<String> neos = ids.list.cast<String>();
    await Future.wait(neos.map((id) async {
      final url = '$neoAPIUrl/neo/$id?api_key=${ApiKey().apiKey}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        neoList.add(AsteroidData.fromJson(json));
      } else {
        // Handle error
        throw Exception('Failed to fetch NEO data for ID: $id');
      }
    }));
    return neoList;
  }
}

final neoProvider = Provider<NeoApi>((ref) => NeoApi());
