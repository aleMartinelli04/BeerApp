import 'package:BeerApp/api/punk_api.dart';
import 'package:BeerApp/pages/homepage.dart';
import 'package:BeerApp/pages/login_page.dart';
import 'package:BeerApp/pages/profile_page.dart';
import 'package:BeerApp/pages/search_page.dart';
import 'package:BeerApp/pages/infinite_scroll_page.dart';
import 'package:flutter/material.dart';

import '../db/db.dart';
import '../utilities/beer_card.dart';
import '../utilities/exception_alert.dart';

class PageManager extends StatefulWidget {
  const PageManager({super.key});

  @override
  PageManagerState createState() => PageManagerState();
}

class PageManagerState extends State<PageManager> {
  final List<Widget> _widgets = [
    const HomePage(),
    const SearchPage(),
    _createFavoritesPage(),
    _createShopListPage(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (Database().currentUser == null) {
      return const LoginPage();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('BeerApp'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            )
          ],
        ),
        body: _widgets[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'ShopList',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ));
  }

  static InfiniteScrollPage _createFavoritesPage() {
    return InfiniteScrollPage<Beer>(
        itemsPerRequest: 8,
        firstPageKey: 1,
        itemBuilder: (context, beer, index) => BeerCard(beer),
        fetchPage: (context, pageKey, itemsPerRequest, pagingController) {
          punkApi
              .getBeersByIDs(Database().currentUser.getFavorites(),
                  page: pageKey)
              .then((beers) {
            final isLastPage = beers.length < itemsPerRequest;
            if (isLastPage) {
              pagingController.appendLastPage(beers);
            } else {
              final nextPageKey = pageKey + 1;
              pagingController.appendPage(beers, nextPageKey);
            }

            if (beers.isEmpty && !isLastPage) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("No favorites"),
                      content: const Text("You have no favorites"),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
              return;
            }
          }).catchError((e) {
            showDialog(
                context: context, builder: ExceptionAlertDialog(e).build);
          });
        },
        build: (context, content, _) => content);
  }

  static InfiniteScrollPage _createShopListPage() {
    return InfiniteScrollPage(
        itemsPerRequest: 8,
        firstPageKey: 1,
        itemBuilder: (context, beer, index) => BeerCard(beer),
        fetchPage: (context, pageKey, itemsPerRequest, pagingController) {
          punkApi
              .getBeersByIDs(Database().currentUser.getShopList(),
                  page: pageKey)
              .then((beers) {
            final isLastPage = beers.length < itemsPerRequest;
            if (isLastPage) {
              pagingController.appendLastPage(beers);
            } else {
              final nextPageKey = pageKey + 1;
              pagingController.appendPage(beers, nextPageKey);
            }

            if (beers.isEmpty && !isLastPage) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Shop List"),
                      content: const Text("You have no beers here"),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
          }).catchError((e) {
            showDialog(
                context: context, builder: ExceptionAlertDialog(e).build);
          });
        },
        build: (context, content, pagingController) {
          return Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_checkout),
                    onPressed: Database().currentUser.getShopList().isEmpty
                        ? null
                        : () {
                            User user = Database().currentUser;
                            int beerCount = user.getShopList().length;

                            user.getShopList().clear();
                            Database().updateUser(user);

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Shop List"),
                                    content: Text(
                                        "You have bought $beerCount beers"),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                            pagingController.refresh();
                          },
                  ),
                ],
              ),
              Expanded(
                child: content,
              ),
            ],
          );
        });
  }
}
