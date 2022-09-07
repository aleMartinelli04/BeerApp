import 'package:flutter/material.dart';

import '../api/punk_api.dart';

class BeerPopup extends AlertDialog {
  final Beer beer;
  final BuildContext context;

  const BeerPopup(this.beer, this.context,
      {super.key, super.title, super.content, super.actions});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (beer.image != null) {
      children.add(Center(
        child: Image.network(beer.image!, width: 100, height: 100),
      ));
    }

    if (beer.abv != -1) {
      children.add(Text("ABV: ${beer.abv}   "));
    }

    if (beer.ibu != -1) {
      children.add(Text("IBU: ${beer.ibu}"));
    }

    children.add(Text("First brewed: ${beer.firstBrewed}\n"));

    children.add(Text("${beer.description}\n"));

    children.add(const Text("Food pairings:"));
    children.add(Text(
      beer.foodPairing.map((p) => " • $p").join("\n"),
    ));

    return AlertDialog(
      title: Text(beer.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
