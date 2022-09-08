import 'dart:math';

import 'package:flutter_map/src/geo/latlng_bounds.dart';
import 'package:latlong2/latlong.dart';

class SavedBreweries {
  static final SavedBreweries _instance = SavedBreweries._internal();

  factory SavedBreweries() => _instance;

  SavedBreweries._internal();

  late final List<Brewery> _breweries = [
    Brewery(
      link: "https://goo.gl/maps/Sx12nW4s5DyfDBdC8",
      name: "Revel",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipPrDvwHhNZNebG13n6ZKB8ZKPRw4ouKiWxjPHpe=w408-h306-k-no",
      city: "Treviglio",
      latitude: 45.51329305937672,
      longitude: 9.589361858038654,
    ),
    Brewery(
      link: "https://goo.gl/maps/JET7szcW5EwNZpVr6",
      name: "Birreria Nuovo Faro",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipOAcHjK1Z_PJOj1ggkcsrV4JbqO-q3FtHRKEd1C=w408-h544-k-no",
      city: "Lodi",
      latitude: 45.33664399614847,
      longitude: 9.487007585622967,
    ),
    Brewery(
      link: "https://goo.gl/maps/aD9WdSd26hVRiVMC9",
      name: "Bierfabrik Milano",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipNNKlINYWMuT8kzX9w8RZxh0EUStWOLg0qhQKFU=w408-h725-k-no",
      city: "Milano",
      latitude: 45.48338659999398,
      longitude: 9.212605611770785,
    ),
    Brewery(
      link: "https://goo.gl/maps/wHqeXWFDU4b4Btj89",
      name: "Hog Beer",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipOqmthPl4SYI6byzBDa3JZi_dXVUfg2nPogvw08=w426-h240-k-no",
      city: "Bergamo",
      latitude: 45.69326476378775,
      longitude: 9.622432872273277,
    ),
    Brewery(
      link: "https://goo.gl/maps/gzaYH2wna7eefg6Q6",
      name: "Amos Platz",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipNk-vqudAkJD2qf4Ww9G8zaG9y0yXehHdUw3YQ-=w408-h544-k-no",
      city: "Crema",
      latitude: 45.364830325508336,
      longitude: 9.690991797501342,
    ),
    Brewery(
      link: "https://goo.gl/maps/tMp3uJiFGKuRdTxS8",
      name: "Half Crown Pub",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipPkCV1MH6arUt3UnsuGzWS8Nkbc7n7spO3_u6dC=w408-h272-k-no",
      city: "Antegnate",
      latitude: 45.48305208668106,
      longitude: 9.789726972986298,
    ),
  ];

  get breweries => _breweries;

  Brewery getRandom() {
    return _breweries[Random().nextInt(_breweries.length)];
  }

  List<Brewery> getWithinArea(LatLngBounds? bounds) {
    if (bounds == null) {
      return [];
    }
    return _breweries.where((brewery) {
      return bounds.contains(LatLng(brewery.latitude, brewery.longitude));
    }).toList();
  }
}

class Brewery {
  final String link;
  final String name;
  final String image;
  final String city;
  final double latitude;
  final double longitude;

  Brewery({
    required this.link,
    required this.name,
    required this.image,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  get latLong => LatLng(latitude, longitude);
}
