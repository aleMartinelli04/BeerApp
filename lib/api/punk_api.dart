import 'dart:convert';

import 'package:http/http.dart' as http;

var punkApi = PunkApi();

class PunkApi {
  Future<List<Beer>> getBeers(LinkBuilder builder) async {
    var response = await http.get(builder.build());
    if (response.statusCode != 200) {
      throw Exception("Failed to load beers");
    }

    var json = jsonDecode(response.body);

    List<Beer> beers = [];
    for (var beer in json) {
      beers.add(Beer.fromJson(beer));
    }

    if (beers.isEmpty) {
      throw Exception("No beers found");
    }

    return beers;
  }

  Future<List<Beer>> getRandomBeers(int amount) async {
    List<Beer> beers = [];

    for (int i = 0; i < amount; i++) {
      var response =
          await http.get(Uri.parse("https://api.punkapi.com/v2/beers/random"));
      if (response.statusCode != 200) {
        throw Exception("Failed to load beers");
      }

      var json = jsonDecode(response.body);
      beers.add(Beer.fromJson(json[0]));
    }

    return beers;
  }
}

class LinkBuilder {
  final String baseUrl = "https://api.punkapi.com/v2/beers";

  final Map<String, String> params = {};

  LinkBuilder name(String? name) {
    if (name == null) {
      params.remove("beer_name");
    } else {
      params["beer_name"] = name;
    }

    return this;
  }

  LinkBuilder brewedAfter(String mmYyyy) {
    if (mmYyyy.isNotEmpty) {
      params['brewed_after'] = mmYyyy;
    }

    return this;
  }

  LinkBuilder brewedBefore(String mmYyyy) {
    if (mmYyyy.isNotEmpty) {
      params['brewed_before'] = mmYyyy;
    }

    return this;
  }

  LinkBuilder page(int page) {
    if (page > 0) {
      params['page'] = page.toString();
    }

    return this;
  }

  LinkBuilder perPage(int perPage) {
    if (perPage > 0 && perPage <= 80) {
      params['per_page'] = perPage.toString();
    }

    return this;
  }

  Uri build() {
    if (params.isEmpty) {
      return Uri.parse(baseUrl);
    }

    return Uri.parse(
        "$baseUrl?${params.entries.map((e) => "${e.key}=${e.value}").join("&")}");
  }

  void reset() {
    params.clear();
  }
}

class Beer {
  final String name;
  final String firstBrewed;
  final String description;
  final String? image;
  final double abv;
  final double ibu;
  final List<String> foodPairing;

  Beer(this.name, this.firstBrewed, this.description, this.image, this.abv,
      this.ibu, this.foodPairing);

  static Beer fromJson(Map<String, dynamic> json) {
    return Beer(
        json['name'],
        json['first_brewed'],
        json['description'],
        json['image_url'],
        json['abv'] ?? -1,
        json['ibu'] ?? -1,
        json['food_pairing'].map<String>((e) => e.toString()).toList());
  }
}
