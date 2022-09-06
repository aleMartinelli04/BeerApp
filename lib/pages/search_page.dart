import 'package:BeerApp/pages/results_page.dart';
import 'package:BeerApp/pages/year_month_controller.dart';
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
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return ResultsPage(linkBuilder: linkBuilder);
                  }),
                ),
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
