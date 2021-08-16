import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/headline_link.dart';
import 'package:itarashop/common/product_grid.dart';
import 'package:itarashop/common/product_gridview.dart';
import 'package:itarashop/common/product_listview.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/model/Meta.dart';
import 'package:itarashop/model/Product.dart';
import 'package:itarashop/ui/cart/cart_empty.dart';
import 'package:itarashop/ui/cart/viewAll.dart';

class NoData extends StatefulWidget {
  final bool? show;
  bool switchGrid;
  final Function? onAction;
  NoData({Key? key, this.switchGrid = true, this.show = true, this.onAction})
      : super(key: key);

  @override
  _NoDataState createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  final ApiResource apiResource = ApiResource();
  bool? displayGrid;
  Future? getProduct;

  @override
  void initState() {
    // TODO: implement initState
    getProduct = apiResource.getSimilarProducts('ITSP002759');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        displayGrid = widget.switchGrid;
      });
    });
    return widget.show == true
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 18,
                  top: 18,
                ),
                child: Text(
                  'Sorry, we have no products here yet. We are working with our brands to make the best products available to you.\nBelow are products we think you may like.',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Expanded(
                // height: MediaQuery.of(context).size.height * 1.7,
                child: FutureBuilder(
                  future: getProduct,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: ProgressbarCircular(
                          useLogo: true,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('No products available'),
                      );
                    } else {
                      Map data = snapshot.data! as Map;
                      final List<Product> products = data['products'];
                      print(data['meta']);

                      return TheProductsWrap(
                        products: products.sublist(0, 10),
                        headlineText: 'You might also like',
                        meta: data['meta'],
                        displayGrid: displayGrid,
                      );
                    }
                  },
                ),
              )
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 18,
                  top: 18,
                ),
                child: Text(
                  "We couldn't find any product matching your search.",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primaryVariant),
                onPressed: () {
                  widget.onAction!();
                },
                child: Text('CLEAR ALL FILTERS'),
              )
            ],
          );
  }
}

class TheProductsWrap extends StatelessWidget {
  TheProductsWrap(
      {Key? key,
      required this.products,
      this.headlineText,
      this.meta,
      this.displayGrid})
      : super(key: key);
  final List<Product> products;
  final String? headlineText;
  final Meta? meta;
  bool? displayGrid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HeadlineLink(
        //   title: headlineText,
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ViewAll(
        //           meta: meta,
        //           appBarTitle: headlineText,
        //           products: products,
        //         ),
        //       ),
        //     );
        //   },
        // ),
        SizedBox(height: 20),
        displayGrid!
            ? ProductGridView(
                result: products,
                meta: meta,
                fetchMore: null,
              )
            : ProductListView(result: products, meta: meta, fetchMore: null)

        // Padding(
        //   padding: const EdgeInsets.only(left: 1, right: 1),
        //   child: Wrap(
        //     spacing: 0,
        //     runSpacing: 0,
        //     direction: Axis.vertical,
        //     children: products
        //         .map(
        //           (e) => ConstrainedBox(
        //             constraints: BoxConstraints(
        //                 maxWidth: MediaQuery.of(context).size.width * 0.4),
        //             child: ProductGrid(
        //               product: e,
        //             ),
        //           ),
        //         )
        //         .toList(),
        //   ),
        // ),
        // Expanded(
        //   child: Wrap.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: 10,
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: index == 0
        //             ? EdgeInsets.only(left: 20.0, right: 12.0)
        //             : EdgeInsets.only(right: 12.0),
        //         child: ProductGrid(
        //           product: products[index],
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
