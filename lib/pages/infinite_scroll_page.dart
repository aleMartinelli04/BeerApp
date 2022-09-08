import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteScrollPage<T> extends StatefulWidget {
  final int itemsPerRequest;
  final int firstPageKey;
  final ItemWidgetBuilder itemBuilder;
  final Function fetchPage;
  final Function build;

  const InfiniteScrollPage(
      {super.key,
      required this.itemsPerRequest,
      required this.firstPageKey,
      required this.itemBuilder,
      required this.fetchPage,
      required this.build});

  @override
  State<StatefulWidget> createState() => InfiniteScrollPageState<T>();
}

class InfiniteScrollPageState<T> extends State<InfiniteScrollPage> {
  late final PagingController<int, T> _pagingController =
      PagingController(firstPageKey: widget.firstPageKey);

  late PagedListView content = PagedListView<int, T>(
    pagingController: _pagingController,
    builderDelegate: PagedChildBuilderDelegate<T>(
      itemBuilder: widget.itemBuilder,
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
    widget.fetchPage(
        context, pageKey, widget.itemsPerRequest, _pagingController);
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, content, _pagingController);
  }
}
