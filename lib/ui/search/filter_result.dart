import 'package:flutter/material.dart';
import 'package:itarashop/ui/category/nodata.dart';
import 'package:recase/recase.dart';

import '../../common/product_gridview.dart';
import '../../model/Meta.dart';
import '../../api/ApiResource.dart';
import '../../common/progressbar_circular.dart';
import '../../common/small_button.dart';
import '../../model/Product.dart';

class FilterResultScreen extends StatefulWidget {
  final Map<String, dynamic> filterData;
  final String query;

  FilterResultScreen({required this.filterData, required this.query});

  @override
  _FilterResultScreenState createState() => _FilterResultScreenState();
}

class _FilterResultScreenState extends State<FilterResultScreen> {
  // Map _filterData;
  List<Product>? _result;
  Meta? _meta;
  bool? _isLoading;

  final ApiResource _apiResource = ApiResource();

  @override
  void initState() {
    // _filterData = widget.filterData;
    _isLoading = true;

    filterSearch();

    super.initState();
  }

  Future filterSearch() async {
    // fetch last search query
    final data =
        await _apiResource.searchProducts(widget.query, widget.filterData);
    setState(() {
      _isLoading = false;
      _result = data['products'] as List<Product>;
      _meta = data['meta'] as Meta;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.filterData);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () => Navigator.pop(context, widget.filterData),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Filter Result',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: (!_isLoading!)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Divider(),
                if (_result == null || _result!.isEmpty)
                  NoData(
                    show: false,
                    onAction: () => Navigator.pop(context, widget.filterData),
                  ),
                // if(_result != null || )
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.filterData.entries.map((filter) {
                      if (filter.value.length == 0) {
                        return SizedBox.shrink();
                      }

                      final isFirst =
                          widget.filterData.entries.first.toString() ==
                              filter.toString();

                      return Padding(
                        padding: isFirst
                            ? EdgeInsets.only(left: 20)
                            : EdgeInsets.only(left: 10),
                        child: SmallButton(
                          title: ReCase(filter.key).titleCase,
                          icon: Icons.clear,
                          onTap: () {
                            setState(() {
                              widget.filterData.remove(filter.key);
                              filterSearch();
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10.0),

                // Product gridview
                ProductGridView(
                  result: _result,
                  meta: _meta,
                  fetchMore: () async {
                    await _apiResource.searchProducts(widget.query, {
                      'pageNumber': _meta!.page! + 1,
                      ...widget.filterData,
                    }).then((result) {
                      setState(() {
                        _meta = result["meta"];
                        _result = _result?..addAll(result['products']);
                      });
                    });
                  },
                ),
              ],
            )
          : Center(
              child: ProgressbarCircular(
                useLogo: true,
              ),
            ),
    );
  }
}
