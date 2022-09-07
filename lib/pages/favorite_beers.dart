import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/punk_api.dart';
import '../db/db.dart';
import '../utilities/beer_card.dart';

class FavoriteBeersPage extends StatefulWidget {
  const FavoriteBeersPage({super.key});

  @override
  State<StatefulWidget> createState() => FavoriteBeersState();
}

class FavoriteBeersState extends State<FavoriteBeersPage> {
  List<Widget> content = [];

  @override
  void initState() {
    setState(() {
      content = [
        const Center(
          heightFactor: 13,
          child: SpinKitFadingCircle(
            color: Colors.brown,
            size: 50.0,
          ),
        )
      ];
    });

    punkApi
        .getBeersByIDs(Database().currentUser.getFavorites())
        .then((beers) {
      if (beers.isEmpty) {
        setState(() {
          content = [
            const Center(
              heightFactor: 13,
              child: Text("No favorite beers"),
            )
          ];
        });
      } else {
        List<Widget> beerCards = [];

        for (var beer in beers) {
          beerCards.add(BeerCard(beer));
        }

        setState(() {
          content = beerCards;
        });
      }
    }).catchError((e) {
      setState(() {
        content = [
          Center(
            heightFactor: 13,
            child: Text(e.toString()),
          )
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: content,
    );
  }
}
