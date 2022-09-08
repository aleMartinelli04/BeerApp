import 'package:BeerApp/db/saved_breweries.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late List<Marker> markers = [];

  late Widget lmao = Container();
  final MapController _controller = MapController();

  @override
  void initState() {
    super.initState();

    final List<Marker> newMarkers = [];
    SavedBreweries().breweries.forEach((brewery) {
      newMarkers.add(Marker(
          width: 40,
          height: 40,
          point: LatLng(brewery.latitude, brewery.longitude),
          builder: (context) => Image.network(
                "https://cdn-icons-png.flaticon.com/512/184/184482.png",
              )));
      setState(() {
        markers = newMarkers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        center: SavedBreweries().getRandom().latLong,
        zoom: 13.0,
        maxZoom: 18.0,
        minZoom: 9.0,
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        onPositionChanged: (MapPosition position, bool hasGesture) {
          if (hasGesture) {
            List<Brewery> visible =
                SavedBreweries().getWithinArea(position.bounds);

            setState(() {
              lmao = Swiper(
                  loop: false,
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    Brewery brewery = visible[index];
                    return Card(
                      child: Row(
                        children: [
                          Image.network(brewery.image),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(brewery.name),
                                Text(
                                  brewery.city,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _controller.move(brewery.latLong, 12.5);
                              },
                              icon: const Icon(Icons.pin_drop_outlined))
                        ],
                      ),
                    );
                  });
            });
          }
        },
      ),
      nonRotatedChildren: [
        SizedBox(height: 100, child: lmao),
      ],
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'BeerApp',
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}
