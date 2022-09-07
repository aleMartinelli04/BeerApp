import 'package:BeerApp/pages/homepage.dart';
import 'package:BeerApp/pages/profile_page.dart';
import 'package:BeerApp/pages/search_page.dart';
import 'package:BeerApp/pages/shoplist_page.dart';
import 'package:flutter/material.dart';

import 'favorite_beers_page.dart';

class PageManager extends StatefulWidget {
  const PageManager({super.key});

  @override
  PageManagerState createState() => PageManagerState();
}

class PageManagerState extends State<PageManager> {
  final List<Widget> _widgets = [
    const HomePage(),
    const SearchPage(),
    const FavoriteBeersPage(),
    const ShopListPage()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BeerApp'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage()));
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
}
