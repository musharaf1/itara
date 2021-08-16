import 'package:flutter/material.dart';
import '../../common/product_gridview.dart';
import '../../common/product_listview.dart';
import '../../common/progressbar_linear.dart';
import '../../api/ApiResource.dart';
import '../../common/filtersort_header.dart';
import '../../model/Meta.dart';
import '../../app_theme.dart';
import '../../model/Product.dart';

class SearchResult extends StatefulWidget {
  final List<Product>? result;
  final Meta? meta;
  final String? query;

  SearchResult({this.result, this.meta, this.query});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  String? _sortParameterSlug;
  List<Product>? _result;
  Meta? _meta;
  bool? _loading;
  bool displayGrid = false;

  final ApiResource _apiResource = ApiResource();

  @override
  void initState() {
    super.initState();

    _result = widget.result;
    _meta = widget.meta;
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.accents["surface"],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _loading!
              ? SizedBox(height: 3, child: ProgressbarLinear())
              : SizedBox(),

          // Sort and filter

          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: FilterSortHeader(
              sortParameterSlug: _sortParameterSlug,
              query: widget.query,
              displayGrid: displayGrid,
              onDisplayGrid: () {
                setState(() {
                  displayGrid = !displayGrid;
                });
              },
              onAction: (sortParameterSlug) {
                setState(() {
                  _sortParameterSlug = sortParameterSlug;
                  _loading = true;

                  refetchQuery();
                });
              },
            ),
          ),

          // Product listview

          (displayGrid)
              ? ProductGridView(
                  result: _result,
                  meta: _meta,
                  fetchMore: () {
                    fetchMore();
                  },
                )
              : ProductListView(
                  result: _result,
                  meta: _meta,
                  fetchMore: () {
                    fetchMore();
                  },
                )
        ],
      ),
    );
  }

  fetchMore() async {
    await _apiResource.searchProducts(
      widget.query!,
      {
        'pageNumber': _meta!.page! + 1,
        'sortParameterSlug': _sortParameterSlug,
      },
    ).then((result) {
      setState(() {
        _meta = result["meta"];
        _result = _result!..addAll(result['products']);
      });
    });
  }

  void refetchQuery() async {
    await _apiResource.searchProducts(
      widget.query!,
      {
        'sortParameterSlug': _sortParameterSlug,
      },
    ).then((result) {
      setState(() {
        _meta = result["meta"];
        _result = result['products'];
        _loading = false;
      });
    });
  }
}
