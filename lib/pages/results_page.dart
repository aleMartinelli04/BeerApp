import 'package:BeerApp/api/punk_api.dart';
import 'package:BeerApp/utilities/beer_card.dart';
import 'package:BeerApp/utilities/exception_alert.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResultsPage extends StatefulWidget {
  final LinkBuilder linkBuilder;

  const ResultsPage({super.key, required this.linkBuilder});

  @override
  ResultsPageState createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  final _numberOfPostsPerRequest = 25;

  final PagingController<int, Beer> _pagingController =
      PagingController(firstPageKey: 1);

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
    try {
      widget.linkBuilder.page(pageKey);
      List<Beer> beers = await punkApi.getBeers(widget.linkBuilder);

      final isLastPage = beers.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(beers);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(beers, nextPageKey);
      }
    } on Exception catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: ExceptionAlertDialog(e).build);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        centerTitle: true,
      ),
      body: PagedListView<int, Beer>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Beer>(
          itemBuilder: (context, item, index) => BeerCard(item),
        ),
      ),
    );
  }
}
