import 'package:flutter/material.dart';
import '../model/Meta.dart';
import '../model/Product.dart';

import 'product_inline.dart';
import 'progressbar_circular.dart';

class ProductListView extends StatefulWidget {
  final List<Product>? result;
  final Meta? meta;
  final Function()? fetchMore;

  ProductListView({@required this.result, @required this.meta, this.fetchMore});

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.result!.length + 2,
        itemBuilder: (context, index) {
          if (index < widget.result!.length + 1) {
            if (index == 0) {
              return SizedBox.shrink();
              // return // TOTAL ITEMS
              //     Padding(
              //   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              //   child: Container(
              //     margin: EdgeInsets.only(bottom: 15.0),
              //     child: Text(
              //       "${widget.meta!.count} Items",
              //       style: Theme.of(context).textTheme.headline6,
              //     ),
              //   ),
              // );
            }
            // PRODUCTS
            final Product product = widget.result![index - 1];

            return Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: ProductInline(product: product),
            );
          } else {
            // Specifies infinit scroll
            if (widget.fetchMore != null) {
              bool nextCursor = widget.meta!.page! <
                  ((widget.meta!.count! / widget.meta!.size!) - 1);

              if (nextCursor) {
                widget.fetchMore!();
                return Center(
                  child: ProgressbarCircular(
                      // useLogo: true,
                      ),
                );
              }
            }
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
