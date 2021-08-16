import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/product_gridview.dart';
import 'package:itarashop/model/Meta.dart';
import 'package:itarashop/model/Product.dart';

class ViewAll extends StatefulWidget {
  final String? appBarTitle;
  final String similarQuery;
  final Meta? meta;
  final List<Product>? products;
  const ViewAll(
      {Key? key,
      this.appBarTitle,
      this.products,
      @required this.meta,
      this.similarQuery = 'ITSP002759'})
      : super(key: key);

  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  List<Product> newProducts = [];
  Meta? meta;
  
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        newProducts = widget.products!;
        meta = widget.meta;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.meta);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          widget.appBarTitle!,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: Column(
        children: <Widget>[
          ProductGridView(
            result: widget.products,
            meta: widget.meta,
            fetchMore: null,
            
            // fetchMore: () async {
              // ApiResource apiResource = ApiResource();
              // await apiResource
              //     .getSimilarProducts(widget.similarQuery,
              //         pageNumber: widget.meta!.page! + 1)
              //     .then((result) {
              //   setState(() {
              //     newProducts = newProducts..addAll(result['products']);
              //     meta = result['meta'];
              //   });
              // });
            // },
          ),
        ],
      ),
    );
  }
}
