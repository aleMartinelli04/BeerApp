import 'package:BeerApp/api/punk_api.dart';
import 'package:BeerApp/utilities/beer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Widget> content = [];
  int index = 1;

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

    punkApi.getBeers(LinkBuilder().perPage(8).page(index)).then((beers) {
      List<Widget> beerCards = [];

      for (var beer in beers) {
        beerCards.add(BeerCard(beer));
      }

      beerCards.add(Container(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              TextButton(
                  onPressed: index == 1
                      ? null
                      : () {
                          index--;
                          if (index <= 0) {
                            index = 1;
                          }

                          initState();
                        },
                  child: const Icon(Icons.skip_previous)),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    index++;
                    initState();
                  },
                  child: const Icon(Icons.skip_next)),
            ],
          )));

      setState(() {
        content = beerCards;
      });
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
