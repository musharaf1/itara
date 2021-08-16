import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/product_grid.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/model/Meta.dart';
import 'package:itarashop/model/Product.dart';
import 'package:itarashop/ui/cart/viewAll.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../common/button_widget.dart';
import '../../common/headline_link.dart';

class CartEmpty extends StatelessWidget {
  final bool? centerTitle;

  CartEmpty({this.centerTitle});

  ApiResource apiResource = ApiResource();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Divider(height: 1.0),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your cart is empty',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Add amazing products to help you live better and achieve more',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   width: 180,
              //   height: 180,
              // ),
              // SvgPicture.asset(
              //   'assets/images/cart_empty.svg',
              //   width: 180,
              //   height: 180,
              //   fit: BoxFit.cover,
              // ),

              if (!centerTitle!)
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Button(
                      label: 'CONTINUE SHOPPING',
                      gradient: 'colored',
                    ),
                  ),
                ),
            ],
          ),
        ),
        Divider(height: 1),
        Container(
          height: MediaQuery.of(context).size.height * 0.42,
          // color: Colors.black,
          child: Center(
            child: FutureBuilder(
              future: apiResource.getSimilarProducts('ITSP002759'
                  // Provider.of<AppState>(context).cartItems[0].product.productNumber
                  ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: ProgressbarCircular(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('No products available'),
                  );
                } else if (snapshot.hasData) {
                  // print(snapshot.data);
                  final Map data = snapshot.data as Map;
                  final List<Product> products = data['products'];
                  print('This is the meta ${(data['meta'] as Meta).page}');

                  return TheProducts(
                    meta: data['meta'],
                    products: products,
                    headlineText: 'Recently Viewed',
                  );
                } else {
                  return Center(
                    child: Text('No products available'),
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class TheProducts extends StatelessWidget {
  const TheProducts(
      {Key? key, required this.products, this.headlineText, this.meta})
      : super(key: key);
  final List<Product> products;
  final String? headlineText;
  final Meta? meta;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadlineLink(
          title: headlineText,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewAll(
                  meta: meta,
                  appBarTitle: headlineText,
                  products: products,
                ),
              ),
            );
          },
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: index == 0
                    ? EdgeInsets.only(left: 20.0, right: 12.0)
                    : EdgeInsets.only(right: 12.0),
                child: ProductGrid(
                  product: products[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
