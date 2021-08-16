import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:itarashop/api/err.dart';
import 'package:itarashop/common/wishlist_dialog.dart';
import 'package:itarashop/ui/home/frontsection_slug_screen.dart';
import 'package:provider/provider.dart';
// import 'package:share_plus/share.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../../ui/product/image_slider.dart';
import '../../api/ApiResource.dart';
import '../../app_state.dart';
import '../../common/addcart.dart';
import '../../common/color_widget.dart';
import '../../common/customer_reviews.dart';
import '../../common/headline_link.dart';
import '../../common/product_grid.dart';
import '../../common/progressbar_circular.dart';
import '../../common/quantity_selector.dart';
import '../../common/rating.dart';
import '../../common/search_widget.dart';
import '../../common/size_widget.dart';
import '../../common/small_button.dart';
import '../../model/Accordion.dart';
import '../../model/Cart.dart';
import '../../model/Product.dart';
import '../../model/ProductSize.dart';
import '../../ui/product/product_accordion.dart';
import 'cusReviews.dart';

class ProductScreen extends StatefulWidget {
  final String? productNumber;

  ProductScreen({@required this.productNumber});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiResource _apiResource = ApiResource();
  int maxQty = 1;
  String? price;
  ProductSize? selectedSize;
  String? productNumber;
  int quantity = 1;
  SizeColor? selectedColor;
  bool isInWishlist = false;

  Future<Product>? _getProduct;

  @override
  void initState() {
    super.initState();

    // initial load
    _getProduct = _apiResource.getProduct(widget.productNumber!);
  }

  // logic for building unique product colors
  List<SizeColor> buildColors(ProductSize productSizes) {
    List<SizeColor> colors = [];

    productSizes.sizeColors!.forEach((item) {
      if (colors.isEmpty) {
        colors.add(item);
      } else {
        var i = colors
            .indexWhere((x) => x.color!.colorCode == item.color!.colorCode);

        if (i <= -1) {
          colors.add(item);
        }
      }
    });

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    // print(this.productNumber);

    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.bodyText1!.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        centerTitle: true,
        titleSpacing: 0,
        title: SearchBar(
          withBackButton: true,
        ),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<Product>(
            future: _getProduct,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Center(
                    child: ProgressbarCircular(
                      useLogo: true,
                    ),
                  ),
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
                            _getProduct =
                                _apiResource.getProduct(widget.productNumber!);
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                );
              } else {
                // initialize product
                if (snapshot.data == null ||
                    snapshot.data!.productNumber!.isEmpty) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Center(
                        child: Text(
                          'This product has been removed or is currently out of stock.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  );
                } else {
                  final Product product = snapshot.data!;
                  print('This is the quantity ${product.remainingStock}');
                  print(
                      'These are the sizes : ${product.productSizes!.length.toString()}');
                  checkWishlist(product);

                  // print(product.toMap());

                  productNumber = product.productNumber;
                  List<SizeColor> _colors = [];

                  // set default Qty and Price from default productSize. First index
                  // print(selectedSize);
                  // print(product.productSizes);

                  if (selectedSize != null) {
                    if (product.productSizes!.isNotEmpty) {
                      //
                      // selectedSize = product.productSizes![0];
                      price =
                          selectedSize!.productSizePrice; //_colors[0].price;
                      maxQty = selectedSize!.productSizeQuantity!;

                      if (selectedSize!.sizeColors!.isNotEmpty) {
                        //
                        _colors = buildColors(selectedSize!);
                        selectedColor = _colors.isNotEmpty ? _colors[0] : null;
                      }
                    } else {
                      price = product.price;
                      maxQty = product.remainingStock!;
                    }
                  } else {
                    price = product.price;
                    maxQty = product.remainingStock!;

                    if (selectedColor != null) {
                      _colors = buildColors(selectedSize!);
                    }
                  }

                  // if (selectedSize == null && product.productSizes.isNotEmpty) {
                  //   selectedSize = product.productSizes[0];

                  //   // print(selectedSize);

                  //   price = selectedSize.price; //_colors[0].price;
                  //   maxQty = selectedSize.quantity; //_colors[0].quantity;

                  //   _colors = buildColors(selectedSize);
                  //   selectedColor = _colors.isNotEmpty ? _colors[0] : null;
                  // } else {
                  //   price = product.price;
                  //   maxQty = product.remainingStock;

                  //   if (selectedSize.productColors != null) {
                  //     _colors = buildColors(selectedSize);
                  //   }

                  //   // color should have price priority over sizes, so overrides it
                  //   if (selectedColor == null) {
                  //     selectedSize.productColors[0];
                  //     price = selectedSize.price;
                  //     maxQty = selectedSize.quantity;
                  //   }
                  // }

                  // build distinct colors

                  // print(selectedSize.toMap());

                  // build product meta
                  List<Accordion> buildAccordionItems() {
                    print(product.specification);
                    return [
                      Accordion(
                        title: 'Brand/Product Story',
                        body: product.productStory,
                        index: 1,
                      ),
                      Accordion(
                        title: 'Product benefits/Specification',
                        body: product.specification,
                        isExpanded: false,
                        index: 2,
                      ),
                      Accordion(
                        title: 'Returns Policy',
                        body: product.returnPolicy,
                        isExpanded: false,
                        index: 3,
                      ),
                      Accordion(
                        title: 'Directions for use/care instructions',
                        body: product.productCareInstruction,
                        isExpanded: false,
                        index: 4,
                      ),
                    ];
                  }

                  // build product

                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        product.productImageUrls!.isNotEmpty
                            ? ImageSlides(slides: product.productImageUrls)
                            : Image(
                                image: NetworkImage(product.defaultImageUrl!),
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: 20.0),

                              product.totalReviews! < 1
                                  ? Text('No reviews yet')
                                  : SizedBox.shrink(),

                              // // rating
                              product.totalReviews! < 1
                                  ? SizedBox.shrink()
                                  : Rating(rating: product.rating),

                              // // reviews
                              product.totalReviews! < 1
                                  ? SizedBox.shrink()
                                  : Text("${product.totalReviews} reviews"),

                              SizedBox(height: 10),

                              // price
                              Text(
                                "₦${price}",
                                style: textTheme.subtitle2!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),

                              SizedBox(height: 20),

                              // title
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      product.name!,
                                      style: textTheme.headline6!.copyWith(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  IconButton(
                                    onPressed: () async {
                                      String url =
                                          'https://itarashop.page.link/?link=https://itarashop.ng/product/${product.productNumber}&apn=com.itara.marketplace';
                                      WcFlutterShare.share(
                                          sharePopupTitle: 'Share this product',
                                          subject: product.name,
                                          text: url,
                                          mimeType: 'text/plain');

                                      // await Share.share(url);
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      size: 22,
                                    ),
                                    color: Colors.black38,
                                  )
                                ],
                              ),

                              // colors
                              if (_colors.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          _colors.map((SizeColor sizeColor) {
                                        return ColorWidget(
                                          color: sizeColor.color!.colorCode,
                                          selected:
                                              selectedColor!.color?.colorCode ==
                                                  sizeColor.color!.colorCode,
                                          onTap: (color) {
                                            setState(() {
                                              selectedColor = selectedSize!
                                                  .sizeColors!
                                                  .where((element) =>
                                                      element
                                                          .color!.colorCode ==
                                                      color)
                                                  .toList()[0];

                                              price =
                                                  selectedColor?.sizeColorPrice;
                                              maxQty = selectedColor!
                                                  .sizeColorQuantity!;
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                              // sizes
                              if (product.productSizes!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: product.productSizes!
                                          .map((ProductSize productSize) {
                                        return SizeWidget(
                                          productSize: productSize,
                                          // onSelected: true,
                                          onSelected: selectedSize == null
                                              ? false
                                              : selectedSize!.size ==
                                                  productSize.size,

                                          onTap: (_size) {
                                            print('Tapped');
                                            selectedSize = _size;
                                            price = _size.productSizePrice;
                                            maxQty = _size.productSizeQuantity!;

                                            // update price and quantity to color attributes if exist
                                            if (_size.sizeColors!.isNotEmpty) {
                                              selectedColor =
                                                  _size.sizeColors![0];
                                              price =
                                                  selectedColor!.sizeColorPrice;
                                              maxQty = selectedColor!
                                                  .sizeColorQuantity!;
                                            }
                                            setState(() {});

                                            print(selectedSize!.size!.sizeName);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                              SizedBox(height: 20.0),

                              // quantity

                              if (maxQty == 0)
                                Text(
                                  'Out of stock',
                                  style: textTheme.bodyText2!.copyWith(
                                    color: Colors.red,
                                  ),
                                )
                              else
                                QuantitySelector(
                                  max: maxQty,
                                  product: product,
                                  onChange: (int value) {
                                    quantity = value;
                                    setState(() {});
                                  },
                                ),

                              SizedBox(height: 20.0),

                              // description
                              Text(
                                "Description",
                                style: titleStyle,
                              ),

                              SizedBox(height: 10.0),

                              Text(
                                product.description!,
                                style: textTheme.bodyText2!.copyWith(
                                  color: Colors.black54,
                                ),
                              ),

                              SizedBox(height: 10.0),

                              // inventory stype
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (product.inventory != null)
                                        Text(
                                          product.inventory!.name!,
                                          style: textTheme.bodyText2,
                                        ),
                                      Text(
                                        product.productNumber!,
                                        style: textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.info,
                                      size: 16,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () async {
                                      // TODO: add popover
                                      await Get.defaultDialog(
                                        title: 'Information',
                                        titleStyle: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        content: Text(
                                          generateText(product.inventory!.name!
                                              .toLowerCase()),
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    final appstate =
                                        await Provider.of<AppState>(
                                      context,
                                      listen: false,
                                    );

                                    if (appstate.isAuthenticated) {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => WishlistAlert(
                                          userId:
                                              appstate.authenticatedUser!.id,
                                          productNumber: product.productNumber,
                                          onTap: (bool status) {
                                            this.setState(() {
                                              isInWishlist = status;
                                            });
                                          },
                                        ),
                                      );
                                    } else {
                                      //TODO: Add sign in popup
                                      ShowErrors.showErrors(
                                          'You have to Login first');
                                      print("Pop up to sign in");
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                    isInWishlist
                                        ? 'assets/images/heart_active.svg'
                                        : 'assets/images/heart.svg',
                                    color: Colors.orange,
                                    width: 20,
                                    height: 20,
                                  ),
                                  label: Text(
                                    isInWishlist == true
                                        ? 'Product is in Wishlist'
                                        : 'Add to WishList',
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(height: 2),
                        SizedBox(height: 10.0),
                        // Divider(color: Colors.black87,),

                        // meta
                        ProductAccordion(
                          items: buildAccordionItems(),
                        ),

                        // reviews
                        HeadlineLink(
                          title: 'Customer Reviews',
                          show: product.userReviews!.isEmpty ? false : true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerReviewsPage(
                                    reviews: product.userReviews),
                              ),
                            );
                          },
                        ),

                        product.userReviews!.isEmpty
                            ? Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'There are no reviews for this product yet',
                                ),
                              )
                            : CustomerReviews(reviews: product.userReviews),

                        // Suggestions
                        HeadlineLink(
                          title: 'You might also like',
                          show: false,
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => FrontSectionSlugScreen(
                            //         slug: 'frontPageSectionSlug'),
                            //   ),
                            // );
                          },
                        ),
                        FutureBuilder(
                          future: _apiResource.getSimilarProducts(
                            product.productNumber!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: ProgressbarCircular(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('No products available'),
                              );
                            } else {
                              final Map data = snapshot.data! as Map;
                              final List<Product> products = data['products'];

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      products.asMap().entries.map((item) {
                                    return Padding(
                                      padding: item.key == 0
                                          ? EdgeInsets.only(
                                              left: 20.0, right: 12.0)
                                          : EdgeInsets.only(right: 12.0),
                                      child: ProductGrid(
                                        product: item.value,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 100.0),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      bottomSheet: BottomSheet(
        enableDrag: false,
        onClosing: () {},
        builder: (BuildContext context) {
          /// Retrieves product promise from async _getProduct state
          /// Fetches once  due to state bindings for performance.
          ///
          /// returns promise, [product]
          return FutureBuilder<Product>(
            future: _getProduct,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final Product _product = snapshot.data!;

                return Consumer<AppState>(
                  builder: (context, appstate, child) {
                    return AddCart(
                      product: _product,
                      maxQty: maxQty,
                      onTap: () {
                        if (_product.productSizes!.isNotEmpty) {
                          if (selectedSize == null) {
                            ShowErrors.showErrors('Please select a size');
                          } else {
                            int length = appstate.cartItems.length;
                            List<CartItem> items = appstate.cartItems;
                            if (length > 30) {
                              ShowErrors.showErrors(
                                  'Maximum number of items per order reached');
                            } else {
                              // for (int i = 0; i < items.length; i++) {
                              //   Prod
                              // }
                              List<CartItem> singlePiece = items
                                  .where((element) =>
                                      element.product!.inventory!.name!
                                          .toLowerCase() ==
                                      'single piece')
                                  .toList();

                              List<CartItem> limitedQuantity = items
                                  .where((element) =>
                                      element.product!.inventory!.name!
                                          .toLowerCase() ==
                                      'limited quantity')
                                  .toList();

                              List<CartItem> massProduced = items
                                  .where((element) =>
                                      element.product!.inventory!.name!
                                          .toLowerCase() ==
                                      'mass produced')
                                  .toList();

                              if (singlePiece.length == 5) {
                                ShowErrors.showErrors(
                                    'Maximum number of single piece products reached per order');
                              } else if (limitedQuantity.length == 10) {
                                ShowErrors.showErrors(
                                    'Maximum number of limited piece products reached per order');
                              } else if (massProduced.length == 15) {
                                ShowErrors.showErrors(
                                    'Maximum number of mass-manufactured products reached per order');
                              } else {
                                // add to cart action
                                print(maxQty);

                                // if out of stock, don't add to cart.
                                if (maxQty == 0) return;

                                // add to cart
                                final CartItem cartItem = CartItem(
                                  productNumber: _product.productNumber,
                                  quantity: quantity,
                                  maxQty: maxQty,
                                  isOutOfStock: _product.isOnSale,
                                  product: _product,
                                  productSizeId: selectedSize?.productSizeId,
                                  productSizeLabel:
                                      selectedSize?.size?.sizeName,
                                  sizeColorId: selectedColor?.sizeColorId,
                                  sizeColorLabel:
                                      selectedColor?.color?.colorCode,
                                  price: price,
                                  // productSize: selectedSize != null ? selectedSize : null,
                                  // sizeColor: selectedColor != null ? selectedColor : null,
                                );

                                appstate.addToCart(cartItem);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Item added to cart!'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(milliseconds: 1500),
                                    elevation: 2,
                                  ),
                                );
                              }
                            }
                          }
                        } else {
                          int length = appstate.cartItems.length;
                          List<CartItem> items = appstate.cartItems;
                          if (length > 30) {
                            ShowErrors.showErrors(
                                'Maximum number of items per order reached');
                          } else {
                            // for (int i = 0; i < items.length; i++) {
                            //   Prod
                            // }
                            List<CartItem> singlePiece = items
                                .where((element) =>
                                    element.product!.inventory!.name!
                                        .toLowerCase() ==
                                    'single piece')
                                .toList();

                            List<CartItem> limitedQuantity = items
                                .where((element) =>
                                    element.product!.inventory!.name!
                                        .toLowerCase() ==
                                    'limited quantity')
                                .toList();

                            List<CartItem> massProduced = items
                                .where((element) =>
                                    element.product!.inventory!.name!
                                        .toLowerCase() ==
                                    'mass produced')
                                .toList();

                            if (singlePiece.length == 5) {
                              ShowErrors.showErrors(
                                  'Maximum number of single piece products reached per order');
                            } else if (limitedQuantity.length == 10) {
                              ShowErrors.showErrors(
                                  'Maximum number of limited piece products reached per order');
                            } else if (massProduced.length == 15) {
                              ShowErrors.showErrors(
                                  'Maximum number of mass-manufactured products reached per order');
                            } else {
                              // add to cart action
                              print(maxQty);

                              // if out of stock, don't add to cart.
                              if (maxQty == 0) return;

                              // add to cart
                              final CartItem cartItem = CartItem(
                                productNumber: _product.productNumber,
                                quantity: quantity,
                                maxQty: maxQty,
                                isOutOfStock: _product.isOnSale,
                                product: _product,
                                productSizeId: selectedSize?.productSizeId,
                                productSizeLabel: selectedSize?.size?.sizeName,
                                sizeColorId: selectedColor?.sizeColorId,
                                sizeColorLabel: selectedColor?.color?.colorCode,
                                price: price,
                                // productSize: selectedSize != null ? selectedSize : null,
                                // sizeColor: selectedColor != null ? selectedColor : null,
                              );

                              appstate.addToCart(cartItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Item added to cart!'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(milliseconds: 1500),
                                  elevation: 2,
                                ),
                              );
                            }
                          }
                        }
                      },
                    );
                  },
                );
              }

              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  String generateText(String inventory) {
    switch (inventory) {
      case 'single piece':
        return 'All single piece products are produced in one copy only (1 of 1). If it’s bought, it may not return to the platform. We advise you to purchase as you see it. ';
        break;
      case 'limited quantity':
        return 'Limited quantity products are produced in limited quantities. They are also available for a specific period. If it’s bought, it may not return to the platform. We advise you to purchase as you see it. ';
        break;
      case 'mass produced':
        return 'These products will always be replenished/restocked until the brand decides to discontinue the product.';
        break;
      default:
        return 'This inventory type tells you more about the availability of the products.';
        break;
    }
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
