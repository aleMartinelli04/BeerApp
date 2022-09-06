import 'package:BeerApp/pages/homepage.dart';
import 'package:BeerApp/pages/search_page.dart';
import 'package:flutter/material.dart';

class PageManager extends StatefulWidget {
  const PageManager({super.key});

  @override
  PageManagerState createState() => PageManagerState();
}

class PageManagerState extends State<PageManager> {
  final List<Widget> _widgets = [const HomePage(), const SearchPage()];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BeerApp'),
        ),
        body: _widgets[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            )
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ));
  }
}
