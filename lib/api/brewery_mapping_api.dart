import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

var breweryMappingApi = BreweryMappingApi();

class BreweryMappingApi {
  final String _baseUrl = 'http://beermapping.com/webservice';
  final String _apiKey = '1d0dec692e53fe232ce728a7b7212c52';

  Future<List<Brewery>> locationsCity(String city, {int? items, int? page}) async {
    return await http
        .get(Uri.parse(_buildLink('loccity', query: city)))
        .then((response) async {
      if (response.statusCode != 200) {
        throw Exception('Failed to load breweries');
      }

      var json = jsonDecode(response.body);

      if (items != null && page != null) {
        if (items > json.length) {
          return [];
        }

        json = json.sublist(items * page, items * (page + 1));
      }

      List<Brewery> breweries = [];
      for (var brewery in json) {
        int locId = brewery['id'];

        var location = await locationMap(locId);

        breweries.add(Brewery.fromJson(brewery, location));
      }

      return breweries;
    });
  }

  Future<LatLng> locationMap(int locId) async {
    return await http
        .get(Uri.parse(_buildLink('locmap', query: locId.toString())))
        .then((response) {
      if (response.statusCode != 200) {
        throw Exception('Failed to load breweries');
      }

      var json = jsonDecode(response.body)[0];

      return LatLng(double.parse(json['lat']), double.parse(json['lng']));
    });
  }

  Future<String?> locationImage(int locId) async {
    return await http
        .get(Uri.parse(_buildLink('locimage', query: locId.toString())))
        .then((response) {
      if (response.statusCode != 200) {
        throw Exception('Failed to load breweries');
      }

      var json = jsonDecode(response.body);

      return json[0]['imageurl'];
    });
  }

  String _buildLink(String link, {String? query}) {
    String url = '$_baseUrl/$link/$_apiKey';

    if (query != null) {
      url += '/$query';
    }

    url += '&s=json';

    print(url);

    return url;
  }
}

class Brewery {
  final int id;
  final String name;
  final String city;
  final LatLng location;

  Brewery({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
  });

  static Brewery fromJson(
      Map<String, dynamic> breweryJson, LatLng location) {
    return Brewery(
      id: breweryJson['id'],
      name: breweryJson['name'],
      city: breweryJson['city'],
      location: location,
    );
  }
}
