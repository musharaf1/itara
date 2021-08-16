import 'package:flutter/material.dart';
import 'package:itarashop/model/Meta.dart';
import 'package:itarashop/ui/auth/signin_screen.dart';
import '../../api/ApiResource.dart';
import '../../common/filtersort_header.dart';
import '../../common/product_gridview.dart';
import '../../common/progressbar_circular.dart';
import '../../common/search_widget.dart';
import '../../model/Category.dart';
import 'category_banner.dart';
import 'nodata.dart';

class SubcategoryScreen extends StatefulWidget {
  final String? categoryTitle;
  final Category? subcategory;
  final FlowType flowType;
  final String? deepLinkSubCat;

  SubcategoryScreen(
      {@required this.categoryTitle,
      this.subcategory,
      this.flowType = FlowType.Normal,
      this.deepLinkSubCat});

  @override
  _SubcategoryScreenState createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final ApiResource _apiResource = ApiResource();
  Future? _getProducts;
  bool displayGrid = true;
  String? sortParameterSlug;
  Meta meta = Meta(page: 0);

  Future<Map> getProducts() async {
    print('This is the title ${widget.categoryTitle}');
    String categorySlug = widget.flowType == FlowType.Normal
        ? widget.subcategory!.categorySlug!
        : widget.deepLinkSubCat!;
    print('This is the title $categorySlug');
    return await _apiResource.listProductsInCategory(
      categorySlug.toLowerCase(),
      itemsPerPage: 20,
      pageNumber: 0,
      sortParameterSlug: sortParameterSlug,
    );
  }

  @override
  void initState() {
    super.initState();

    _getProducts = getProducts();
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
              print(snapshot.data);
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
                Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

                return data['products'].isEmpty
                    ? Expanded(child: NoData(switchGrid: displayGrid,))
                    : Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              pinned: false,
                              floating: false,
                              expandedHeight:
                                  MediaQuery.of(context).size.width - 100,
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
                                  //
                                  String categorySlug =
                                      widget.flowType == FlowType.Normal
                                          ? widget.subcategory!.categorySlug!
                                          : widget.deepLinkSubCat!;
                                  await _apiResource
                                      .listProductsInCategory(
                                    categorySlug.toLowerCase(),
                                    itemsPerPage: 20,
                                    pageNumber:
                                        meta.page!+ 1,
                                    sortParameterSlug: sortParameterSlug!,
                                  )
                                      .then((results) {
                                    setState(() {
                                      meta = data['meta'];
                                      data['products'] = 
                                        data['products']
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
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: <Widget>[
      //     Divider(height: 1.0),
      //     Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 20.0),
      //       child: FilterSortHeader(
      //         displayGrid: displayGrid,
      //         onDisplayGrid: () {
      //           setState(() {
      //             displayGrid = !displayGrid;
      //           });
      //         },
      //       ),
      //     ),
      //     CategoryBanner(
      //       name: widget.subcategory.name,
      //       description: widget.categoryTitle,
      //       imageUrl: widget.subcategory.imageUrl,
      //     ),
      //     Expanded(
      //       child: FutureBuilder(
      //         future: _getProducts,
      //         builder: (BuildContext context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return Center(
      //               child: ProgressbarCircular(
      //                 useLogo: true,
      //               ),
      //             );
      //           } else if (snapshot.hasError) {
      //             print(snapshot.error);
      //             return Center(
      //               child: Text('Unable to load request.'),
      //             );
      //           } else {
      //             return ProductGridView(
      //               meta: snapshot.data['meta'],
      //               result: snapshot.data['products'],
      //               shrink: true,
      //               fetchMore: () {
      //                 //
      //               },
      //             );
      //           }
      //         },
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
