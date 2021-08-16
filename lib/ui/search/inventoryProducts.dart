import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/product_gridview.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/common/small_button.dart';
import 'package:itarashop/model/Meta.dart';
import 'package:itarashop/model/Product.dart';
import 'package:itarashop/ui/category/nodata.dart';

class InventoryProducts extends StatefulWidget {
  final String? inventory;
  const InventoryProducts({Key? key, this.inventory}) : super(key: key);

  @override
  _InventoryProductsState createState() => _InventoryProductsState();
}

class _InventoryProductsState extends State<InventoryProducts> {
  ApiResource apiResource = ApiResource();
  Future<Map>? _getProduct;
  Meta meta = Meta(page: 0, size: 20, count: 1);
  List<Product> products = [];

  @override
  void initState() {
    // TODO: implement initState
    _getProduct = apiResource.listProductsByInventory(widget.inventory!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inventory!,
         style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: FutureBuilder<Map>(
        future: _getProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ProgressbarCircular(useLogo: true),
            );
          } else if (snapshot.hasError) {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Network error or timedout.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100.0,
                      vertical: 10.0,
                    ),
                    child: SmallButton(
                      title: 'Retry request?',
                      color: Colors.black12,
                      textColor: Colors.black87,
                      icon: Icons.refresh,
                      iconColor: Colors.black87,
                      onTap: () {
                        _getProduct = apiResource.getProduct(widget.inventory!) as Future<Map>?;
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!['products'].isEmpty) {
              return NoData();
            } else if (snapshot.hasData) {
              Map data = snapshot.data!;
              products = data['products'];
              // List<Product> products = [];
              // for(int i = 0; i < snapshot.data['products'].length; i++) {
              //   print(snapshot.data['products'][i]);
              //   // Product prod = Product.fromJson(snapshot.data['products'][i]);
              //   // print(prod.name);
              //   // products.add(Product.fromJson(snapshot.data['products'][i]));
              // }
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ProductGridView(
                      result: data['products'],
                      meta: data['meta'],
                      fetchMore: () async {
                        await apiResource
                            .listProductsByInventory(
                          widget.inventory!,
                          pageNumber: meta.page! + 1,
                        )
                            .then((results) {
                          // setState(() {
                          print(results);
                          meta = results['meta'];
                          data['products'].addAll(results['products']);
                          setState(() {});
                          // });
                        });
                      },
                    ),
                  ],
                ),
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
