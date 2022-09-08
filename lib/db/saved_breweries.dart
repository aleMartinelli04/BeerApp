import 'dart:math';

import 'package:flutter_map/src/geo/latlng_bounds.dart';
import 'package:latlong2/latlong.dart';

class SavedBreweries {
  static final SavedBreweries _instance = SavedBreweries._internal();

  factory SavedBreweries() => _instance;

  SavedBreweries._internal();
  
  late final List<Brewery> _breweries = [
    Brewery(
      id: 1,
      name: "Revel",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipPrDvwHhNZNebG13n6ZKB8ZKPRw4ouKiWxjPHpe=w408-h306-k-no",
      city: "Treviglio",
      latitude: 45.51329305937672,
      longitude: 9.589361858038654,
    ),
    Brewery(
      id: 2,
      name: "iBirrattieri",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipNPD8d19EuzUK_YOmQ-D4gIJj8d4OGzlNEVajY=w408-h408-k-no",
      city: "Treviglio",
      latitude: 45.52199195862417,
      longitude: 9.588787256422028,
    ),
    Brewery(
      id: 3,
      name: "Bierfabrik Milano",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipNNKlINYWMuT8kzX9w8RZxh0EUStWOLg0qhQKFU=w408-h725-k-no",
      city: "Milano",
      latitude: 45.48338659999398,
      longitude: 9.212605611770785,
    ),
    Brewery(
      id: 4,
      name: "Hog Beer",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipOqmthPl4SYI6byzBDa3JZi_dXVUfg2nPogvw08=w426-h240-k-no",
      city: "Bergamo",
      latitude: 45.69326476378775,
      longitude: 9.622432872273277,
    ),
    Brewery(
      id: 5,
      name: "Amos Platz",
      image:
          "https://lh5.googleusercontent.com/p/AF1QipNk-vqudAkJD2qf4Ww9G8zaG9y0yXehHdUw3YQ-=w408-h544-k-no",
      city: "Crema",
      latitude: 45.364830325508336,
      longitude: 9.690991797501342,
    ),
    Brewery(
      id: 6,
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
  final int id;
  final String name;
  final String image;
  final String city;
  final double latitude;
  final double longitude;

  Brewery({
    required this.id,
    required this.name,
    required this.image,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  get latLong => LatLng(latitude, longitude);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Brewery fromMap(Map<String, dynamic> map) {
    return Brewery(
      id: int.parse(map['id']),
      name: map['name'],
      image: map['image'],
      city: map['city'],
      latitude: double.parse(map['latitude']),
      longitude: double.parse(map['longitude']),
    );
  }
}
