import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../model/Meta.dart';
import '../model/Product.dart';
import 'product_grid.dart';
import 'progressbar_circular.dart';

class ProductGridView extends StatefulWidget {
  final List<Product>? result;
  final Meta? meta;
  final Function()? fetchMore;
  final bool shrink;
  final bool sliver; // is this a sliver rendered view?

  ProductGridView({
    @required this.result,
    @required this.meta,
    this.sliver = false,
    this.fetchMore,
    this.shrink = false,
  });

  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  @override
  Widget build(BuildContext context) {
    bool next = widget.fetchMore == null ? false : widget.meta!.page! <
                  ((widget.meta!.count! / widget.meta!.size!) - 1);
    if (widget.sliver) {
      return SliverGrid(
        delegate: SliverChildListDelegate(
          List.generate(
            next == true
                ? widget.result!.length + 1
                : widget.result!.length,
            (int index) {
              if (widget.fetchMore == null) {
                final Product product = widget.result![index];
                return ProductGrid(product: product);
              } else {
                if (index < widget.result!.length) {
                  final Product product = widget.result![index];

                  return ProductGrid(product: product);
                } else {
                  // Specifies infinit scroll
                  // bool? nextCursor = widget.meta!.page! <
                  bool nextCursor = widget.meta!.page! <
                      ((widget.meta!.count! / widget.meta!.size!) - 1);

                      print('NextCursor $nextCursor');

                  if (nextCursor) {
                    widget.fetchMore!();
                    return Center(
                      child: ProgressbarCircular(),
                    );
                  }

                  return SizedBox.shrink();
                }
              }
            },
          ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          childAspectRatio: 0.65,
          crossAxisCount: 2,
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        // reverse: true,
        shrinkWrap: widget.shrink,
        physics: widget.shrink
            ? NeverScrollableScrollPhysics()
            : ClampingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 20.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          childAspectRatio: 0.65,
          crossAxisCount: 2,
        ),
        itemCount: next == true
            ? widget.result!.length + 2
            : widget.result!.length,
        itemBuilder: (BuildContext context, int index) {
          // Tips: check if list has meta, to prevent spaces at the bottom
          // if (widget.length, or widget.length + 1 ) instead

          if (widget.fetchMore == null) {
            final Product product =
                widget.result![(widget.result!.length - 1) - index];
            return ProductGrid(product: product);
          } else {
            if (index < widget.result!.length) {
              final Product product =
                  widget.result![(widget.result!.length - 1) - index];

              return ProductGrid(product: product);
            } else {
              // Specifies infinit scroll

              bool nextCursor = widget.meta!.page! <
                  ((widget.meta!.count! / widget.meta!.size!) - 1);
              print(nextCursor);

              if (nextCursor) {
                widget.fetchMore!();
                return Shimmer.fromColors(
                  baseColor: Colors.black38.withAlpha(50),
                  highlightColor: Colors.black12,
                  child: Container(
                    width: 100,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
                // return Padding(
                //   padding: EdgeInsets.only(
                //     left: MediaQuery.of(context).size.width * 0.2,
                //   ),
                //   child: Center(
                //     child: Container(
                //       width: 40,
                //       height: 40,
                //       color: Colors.red,
                //       child: ProgressbarCircular(),
                //     ),
                //   ),
                // );
              }

              return SizedBox.shrink();
            }
          }
        },
      ),
    );
  }
}
