import 'package:flutter/material.dart';

import '../api/punk_api.dart';
import '../db/db.dart';
import 'beer_popup.dart';

class BeerCard extends StatefulWidget {
  final Beer _beer;

  const BeerCard(this._beer, {super.key});

  @override
  State<StatefulWidget> createState() => BeerCardState();
}

class BeerCardState extends State<BeerCard> {
  @override
  Widget build(BuildContext context) {
    bool isFavorite =
        Database().currentUser.getFavorites().contains(widget._beer.id);

    bool isShopList =
        Database().currentUser.getShopList().contains(widget._beer.id);

    var leading = widget._beer.image == null
        ? const Icon(Icons.image)
        : Image.network(widget._beer.image!);

    var subtitle = widget._beer.abv == -1
        ? Text("IBU: ${widget._beer.ibu}")
        : widget._beer.ibu == -1
            ? Text("ABV: ${widget._beer.abv}")
            : Text("ABV: ${widget._beer.abv}\nIBU: ${widget._beer.ibu}");

    return Card(
      child: ListTile(
        leading: leading,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: isFavorite
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                setState(() => isFavorite = !isFavorite);

                if (isFavorite) {
                  Database().currentUser.addFavorite(widget._beer.id);
                } else {
                  Database().currentUser.removeFavorite(widget._beer.id);
                }
              },
            ),
            IconButton(
              icon: isShopList
                  ? const Icon(Icons.shopping_bag, color: Colors.green)
                  : const Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                setState(() => isShopList = !isShopList);

                if (isShopList) {
                  Database().currentUser.addShopList(widget._beer.id);
                } else {
                  Database().currentUser.removeShopList(widget._beer.id);
                }
              },
            ),
          ],
        ),
        title: Text(widget._beer.name),
        subtitle: subtitle,
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return BeerPopup(widget._beer, context);
            }),
      ),
    );
  }
}
