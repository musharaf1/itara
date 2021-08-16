import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/filtersort_header.dart';
import 'package:itarashop/common/product_gridview.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/common/search_widget.dart';
import 'package:itarashop/model/Category.dart';
import 'package:itarashop/model/Meta.dart';
import 'package:itarashop/ui/auth/signin_screen.dart';

import 'category_banner.dart';

class ProductsTag extends StatefulWidget {
  final String? categoryTitle;
  final Category? subcategory;
  final FlowType? flowType;
  final String? deepLinkSubCat;
  const ProductsTag(
      {Key? key,
      this.categoryTitle,
      this.subcategory,
      this.flowType,
      this.deepLinkSubCat})
      : super(key: key);

  @override
  _ProductsTagState createState() => _ProductsTagState();
}

class _ProductsTagState extends State<ProductsTag> {
  final ApiResource _apiResource = ApiResource();
  Future? _getProducts;
  bool displayGrid = false;
  String? sortParameterSlug;
  Meta meta = Meta(page: 0);

  Future<Map> getProducts() async {
    return await _apiResource.listProductsByTag(
      widget.flowType == FlowType.Normal
          ? widget.subcategory!.categorySlug!
          : widget.deepLinkSubCat!,
      itemsPerPage: 20,
      pageNumber: 0,
      sortParameterSlug: sortParameterSlug!,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getProducts = getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          Divider(
            height: 1.0,
          ),
          Container(
            // constraints: BoxConstraints.expand(),
            color: Colors.white,
            // alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: FilterSortHeader(
              displayGrid: displayGrid,
              onDisplayGrid: () {
                setState(() {
                  displayGrid = !displayGrid;
                });
              },
              sortParameterSlug: sortParameterSlug,
              onAction: (val) {
                this.setState(() {
                  sortParameterSlug = val;
                });

                // _getProducts;
              },
            ),
          ),
          FutureBuilder(
            future: _getProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Center(
                    child: ProgressbarCircular(
                      useLogo: true,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Expanded(
                  child: Center(
                    child: Text('Unable to load request.'),
                  ),
                );
              } else {
                Map data = snapshot.data! as Map;
                return Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: false,
                        floating: false,
                        expandedHeight: MediaQuery.of(context).size.width - 100,
                        centerTitle: false,
                        flexibleSpace: CategoryBanner(
                          name: widget.flowType == FlowType.Normal
                              ? widget.subcategory!.name
                              : widget.categoryTitle,
                          description: widget.categoryTitle,
                          imageUrl: widget.flowType == FlowType.Normal
                              ? widget.subcategory!.imageUrl
                              : "https://cdn.pixabay.com/photo/2019/09/04/05/53/moon-4450739_1280.jpg",
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: ProductGridView(
                          sliver: true,
                          meta: data['meta'],
                          result: data['products'],
                          shrink: true,
                          fetchMore: () async {
                            await _apiResource
                                .listProductsByTag(
                              widget.flowType == FlowType.Normal
                                  ? widget.subcategory!.categorySlug!
                                  : widget.deepLinkSubCat!,
                              itemsPerPage: 20,
                              pageNumber: meta.page! + 1,
                              sortParameterSlug: sortParameterSlug!,
                            )
                                .then((results) {
                              setState(() {
                                meta = data['meta'];
                                data['products'] = data['products']
                                  ..addAll(results['products']);
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
