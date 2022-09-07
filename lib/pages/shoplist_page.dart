import 'package:BeerApp/utilities/exception_alert.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../api/punk_api.dart';
import '../db/db.dart';
import '../utilities/beer_card.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({super.key});

  @override
  State<StatefulWidget> createState() => ShopListPageState();
}

class ShopListPageState extends State<ShopListPage> {
  final _numberOfPostsPerRequest = 8;

  final PagingController<int, Beer> _pagingController =
  PagingController(firstPageKey: 1);

  late PagedListView content = PagedListView<int, Beer>(
    pagingController: _pagingController,
    builderDelegate: PagedChildBuilderDelegate<Beer>(
      itemBuilder: (context, beer, index) => BeerCard(beer),
    ),
  );

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    punkApi
        .getBeersByIDs(Database().currentUser.getShopList(), page: pageKey)
        .then((beers) {

      final isLastPage = beers.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(beers);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(beers, nextPageKey);
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
      showDialog(context: context, builder: ExceptionAlertDialog(e).build);
    });
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
