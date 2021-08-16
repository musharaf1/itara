import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itarashop/common/product_grid.dart';
import 'package:itarashop/common/wishlist_dialog.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../model/Product.dart';
import '../../common/buy_label.dart';
import '../../common/headline_link.dart';
import '../../model/FrontPageSection.dart';

class LatestProducts extends StatefulWidget {
  final FrontPageSection? section;

  LatestProducts({this.section});

  @override
  _LatestProductsState createState() => _LatestProductsState();
}

class _LatestProductsState extends State<LatestProducts> {
  bool isInWishlist = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
    return Column(
      children: <Widget>[
        HeadlineLink(
          title: widget.section!.name,
          onTap: () {
            
            Navigator.of(context).pushNamed(
              '/frontsection-slug',
              arguments: {'slug': widget.section!.frontPageSectionSlug, 'latest': true},
            );
          },
        ),
        SizedBox(height: 5),
        Container(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.section!.products!.length,
            itemBuilder: (BuildContext context, int index) {
              final Product product = widget.section!.products![index];
              checkWishlist(product);

              return Padding(
                padding: index == 0
                    ? EdgeInsets.only(left: 20.0, right: 12.0)
                    : EdgeInsets.only(right: 12.0),
                  child: ProductGrid(
                product: product,
              ));
            },
          ),
        )
      ],
    );
  }

  Future<void> checkWishlist(Product product) async {
    try {
      final _flutterSecureStorage = FlutterSecureStorage();

      String? _storeWishlists =
          await _flutterSecureStorage.read(key: 'wishlists');
      if (_storeWishlists != null) {
        final wishlist = List.from(json.decode(_storeWishlists))
            .firstWhere((e) => e.split("##").last == product.productNumber);

        isInWishlist = wishlist.isNotEmpty && wishlist.contains("##");

        this.setState(() {});
      }
    } catch (e) {
      print('nothing found');
    }
  }
}

// GestureDetector(
//                 onTap: () => Navigator.of(context).pushNamed(
//                   '/product',
//                   arguments: {'productNumber': product.productNumber},
//                 ),
//                 child: Container(
//                   width: 180,
//                   // height: 20,
//                   // width: MediaQuery.of(context).size.width * 0.65,
//                   margin: EdgeInsets.only(
//                     left: index == 0 ? 20 : 0,
//                     right:
//                         index == widget.section.products.length - 1 ? 20.0 : 12,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     // mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 180,
//                         height: 200,
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8.0),
//                               child: Container(
//                                 width: 180,
//                                 height: 200,
//                                 decoration: BoxDecoration(
//                                   color: Color(0xff808080),
//                                   // gradient: LinearGradient(
//                                   //   colors: [
//                                   //     Colors.black.withOpacity(0.1),
//                                   //     // Colors.black87,
//                                   //     Colors.black
//                                   //   ],
//                                   //   begin: FractionalOffset.topCenter,
//                                   //   end: FractionalOffset.bottomCenter,
//                                   //   stops: [0, 0.8],
//                                   // ),
//                                 ),
//                                 child: Image(
//                                   height: 250,
//                                   // color: Color(0xfff6f6f6),
//                                   image: NetworkImage(product.defaultImageUrl),
//                                   fit: BoxFit.cover,
//                                   // colorBlendMode: BlendMode.darken,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(bottom: 8.0, right: 8),
//                               child: Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: GestureDetector(
//                                     onTap: () async {
//                                       final appstate =
//                                           await Provider.of<AppState>(
//                                         context,
//                                         listen: false,
//                                       );

//                                       if (appstate.isAuthenticated) {
//                                         return showDialog(
//                                           context: context,
//                                           builder: (context) => WishlistAlert(
//                                             userId:
//                                                 appstate.authenticatedUser.id,
//                                             productNumber:
//                                                 product.productNumber,
//                                             onTap: (bool status) {
//                                               this.setState(() {
//                                                 isInWishlist = status;
//                                               });
//                                             },
//                                           ),
//                                         );
//                                       } else {
//                                         //TODO: Add sign in popup
//                                         print("Pop up to sign in");
//                                       }
//                                     },
//                                     child: Container(
//                                       width: 25,
//                                       height: 25,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(4.0),
//                                         child: Center(
//                                           child: SvgPicture.asset(
//                                             isInWishlist
//                                                 ? 'assets/images/heart_active.svg'
//                                                 : 'assets/images/heart.svg',
//                                             color: Colors.orange,
//                                             width: 20,
//                                             height: 20,
//                                           ),
//                                         ),
//                                       ),
//                                     )),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         product.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: t.textTheme.bodyText1.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).pushNamed(
//                           '/product',
//                           arguments: {'productNumber': product.productNumber},
//                         ),
//                         child: BuyLabel(
//                           price: product.price,
//                           // comparePrice: '980.00',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
