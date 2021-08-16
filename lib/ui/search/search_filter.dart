import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:intl/intl.dart';
import '../../api/ApiResource.dart';
import '../../common/color_list.dart';
import '../../common/progressbar_circular.dart';
import '../../common/slide_handle.dart';
import '../../common/options_list_tile.dart';
import '../../common/small_button.dart';
import '../../model/Product.dart';

class SearchFilter extends StatefulWidget {
  final String? query;

  SearchFilter({this.query});

  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  Map<String, dynamic> filterData = {
    "inventorySlugs": [],
    "colorCodes": [],
    "returnPolicy": [],
  };
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double _minPrice = 500;
  double _maxPrice = 800000;

  final ApiResource _resource = ApiResource();

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      if (filterData['inventorySlugs'] == null) {
        filterData['inventorySlugs'] = [];
      } else if (filterData['colorCodes'] == null) {
        filterData['colorCodes'] = [];
      } else if (filterData['returnPolicy'] == null) {
        filterData['returnPolicy'] = [];
      }
    }

    final ThemeData t = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      // Remote Fetch
      body: FutureBuilder<List<ProductColor>>(
        future: _resource.colors(),
        builder: (context, snapshot) {
          return ListView(
            children: <Widget>[
              Divider(),
              buildPrice(t),
              Divider(),
              buildColors(t, snapshot),
              Divider(),
              buildInventory(t),
              Divider(),
              buildReturnPolicy(t),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  Padding buildReturnPolicy(ThemeData t) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filterData['returnPolicy'] != null &&
                    filterData['returnPolicy'].length > 0
                ? "Return Policy (${filterData['returnPolicy'].length})"
                : "Return Policy",
            style: t.textTheme.headline6,
          ),
          SizedBox(height: 10),
          Column(
            children: Product.returnPolicyList.map((returnPolicy) {
              return OptionsListTile(
                title: returnPolicy,
                contentPadding: EdgeInsets.zero,
                // isSelected: true,
                isSelected: filterData['returnPolicy'].contains(returnPolicy),
                onAction: () {
                  setState(
                    () {
                      if (filterData['returnPolicy'].contains(returnPolicy)) {
                        filterData['returnPolicy'].remove(returnPolicy);
                      } else {
                        filterData['returnPolicy'].add(returnPolicy);
                      }
                    },
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      title: Text(
        'Filter',
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
          child: FittedBox(
              child: TextButton(
            onPressed: () async {
              final hook = await Navigator.of(context).pushNamed(
                '/search-filter-result',
                arguments: {
                  'filterData': filterData,
                  'query': widget.query,
                },
              );
              filterData = hook as Map<String, dynamic>;
              setState(() {});
            },
            child: Text('Apply'),
          )),
        ),
      ],
    );
  }

  Padding buildPrice(ThemeData t) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Price (₦)', style: t.textTheme.headline6),
          FlutterSlider(
            rangeSlider: true,
            values: [
              _minPrice,
              filterData['highestPrice'] == null ? 800000 : _maxPrice
            ],
            min: 500,
            max: 1400000,
            onDragging: (handleIndex, lowerValue, upperValue) {
              _minPrice = lowerValue;
              _maxPrice = upperValue;

              filterData['highestPrice'] = _maxPrice.toStringAsFixed(0);

              setState(() {});
            },
            // tooltip: FlutterSliderTooltip(
            //   alwaysShowTooltip: false,
            //   custom: (value) {
            //     value = NumberFormat.currency(symbol: '₦', decimalDigits: 0)
            //         .format(value);
            //     return Text(
            //       value,
            //       style: t.textTheme.body2,
            //     );
            //   },
            //   positionOffset: FlutterSliderTooltipPositionOffset(
            //     top: 60.0,
            //   ),
            // ),
            handler: FlutterSliderHandler(
              // disabled: true,
              decoration: BoxDecoration(),
              child: SlideHandle(),
            ),
            rightHandler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: SlideHandle(),
            ),
            trackBar: FlutterSliderTrackBar(
              activeTrackBarHeight: 2,
              inactiveTrackBarHeight: 2,
              inactiveTrackBar: BoxDecoration(
                color: Colors.black12,
                border: Border.all(
                  width: 2,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              activeTrackBar: BoxDecoration(
                color: t.colorScheme.primaryVariant,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    NumberFormat.currency(symbol: '₦', decimalDigits: 0)
                        .format(_minPrice),
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    NumberFormat.currency(symbol: '₦', decimalDigits: 0)
                        .format(_maxPrice),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Padding buildColors(ThemeData t, AsyncSnapshot<List<ProductColor>> snapshot) {
    print(filterData['colorCodes']);
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            filterData['colorCodes'] != null &&
                    filterData['colorCodes'].length > 0
                ? "Colors (${filterData['colorCodes'].length})"
                : "Colors",
            style: t.textTheme.headline6,
          ),
          SizedBox(height: 10),
          snapshot.hasData
              ? ColorList(
                  colors: snapshot.data,
                  selected: filterData['colorCodes'],
                  onSelect: (color) {
                    print(color);
                    setState(() {
                      filterData['colorCodes'] = color;
                    });
                  },
                )
              : SizedBox(
                  height: 18,
                  width: 18,
                  child: ProgressbarCircular(),
                )
        ],
      ),
    );
  }

  Padding buildInventory(ThemeData t) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
              filterData['inventorySlugs'] != null &&
                      filterData['inventorySlugs'].length > 0
                  ? "Inventory type (${filterData['inventorySlugs'].length})"
                  : "Inventory type",
              style: t.textTheme.headline6),
          SizedBox(height: 10),
          Column(
            children: Product.inventories.map((inventory) {
              return OptionsListTile(
                title: inventory,
                contentPadding: EdgeInsets.zero,
                isSelected: filterData['inventorySlugs'].contains(inventory),
                onAction: () {
                  setState(() {
                    if (filterData['inventorySlugs'].contains(inventory)) {
                      filterData['inventorySlugs'].remove(inventory);
                    } else {
                      filterData['inventorySlugs'].add(inventory);
                    }
                  });
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
