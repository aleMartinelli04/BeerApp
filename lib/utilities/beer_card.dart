import 'dart:html';

import 'package:flutter/material.dart';

import '../api/punk_api.dart';
import 'beer_popup.dart';

class BeerCard extends Card {
  final Beer beer;

  const BeerCard(this.beer, {super.key});

  @override
  Widget build(BuildContext context) {
    var leading = beer.image == null
        ? const Icon(Icons.image)
        : Image.network(beer.image!);

    var subtitle = beer.abv == -1
        ? Text("IBU: ${beer.ibu}")
        : beer.ibu == -1
            ? Text("ABV: ${beer.abv}")
            : Text("ABV: ${beer.abv}\nIBU: ${beer.ibu}");

    return Card(
      child: ListTile(
        leading: leading,
        title: Text(beer.name),
        subtitle: subtitle,
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return BeerPopup(beer, context);
            }),
      ),
    );
  }
}
