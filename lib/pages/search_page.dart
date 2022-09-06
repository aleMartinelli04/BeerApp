import 'package:BeerApp/pages/year_month_controller.dart';
import 'package:BeerApp/utilities/beer_card.dart';
import 'package:BeerApp/utilities/year_month_picker.dart';
import 'package:flutter/material.dart';

import '../api/punk_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  LinkBuilder linkBuilder = LinkBuilder();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    final YearMonthController brewedBeforeController =
        YearMonthController(linkBuilder.brewedBefore);

    final YearMonthController brewedAfterController =
        YearMonthController(linkBuilder.brewedAfter);

    return ListView(
      padding: const EdgeInsets.only(left: 18, top: 10, right: 18),
      children: [
        TextFormField(
          decoration: const InputDecoration(
            label: Text("Name"),
          ),
          controller: nameController,
        ),
        const Padding(padding: EdgeInsets.all(10)),
        const Text("Brewed before"),
        YearMonthPicker(brewedBeforeController),
        const Padding(padding: EdgeInsets.all(10)),
        const Text("Brewed after"),
        YearMonthPicker(brewedAfterController),
        const Padding(padding: EdgeInsets.all(10)),
        TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                linkBuilder.name(nameController.text.replaceAll(" ", "_"));
              } else {
                linkBuilder.name(null);
              }

              punkApi.getBeers(linkBuilder).then((beers) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text("Search results"),
                      ),
                      body: ListView(
                        children: beers.map((beer) => BeerCard(beer)).toList(),
                      ),
                    ),
                  ),
                );
              }).catchError((e) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text("Search results"),
                      ),
                      body: Text(e.toString().split("Exception: ")[1]),
                    ),
                  ),
                );
              });
            },
            child: const Text("Search")),
        TextButton(
            onPressed: () {
              linkBuilder.reset();

              nameController.clear();
              setState(() {});
            },
            child: const Text("Reset"))
      ],
    );
  }
}
