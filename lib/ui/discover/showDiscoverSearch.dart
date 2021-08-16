import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:itarashop/app_state.dart';
import 'package:itarashop/transformers/ProductTransformer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../api/ApiResource.dart';
import '../../model/Product.dart';
import '../../ui/discover/discover_categories.dart';
import 'package:shimmer/shimmer.dart';
import '../../common/search_widget.dart';

class ShowDiscoverSearch extends StatefulWidget {
  final String? query;

  const ShowDiscoverSearch({Key? key, this.query}) : super(key: key);
  @override
  _ShowDiscoverSearchState createState() => _ShowDiscoverSearchState();
}

class _ShowDiscoverSearchState extends State<ShowDiscoverSearch>
    with TickerProviderStateMixin {
  final ApiResource _apiResource = ApiResource();
  Future? fetchDiscoveries;
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    fetchDiscoveries = _apiResource.discover(query: widget.query!);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  int refreshCount = 0;

  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          centerTitle: true,
          titleSpacing: 0,
          title: Text(widget.query!, style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              enablePullDown: true,
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Center(
                      child: Text(
                        'Unable to load request. \n Network timedout',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              onRefresh: () async {
                print('triggered 0');
                print(refreshCount);
                bool ref = refreshCount > 0;
                Map<String, dynamic>? data =
                    await fromMock(ref, widget.query!) as Map<String, dynamic>;

                if (data.isNotEmpty) {
                  if (refreshCount > 0) {
                    setState(() {
                      products.clear();
                      products = data['products'];
                    });
                    // products = data['products'];
                  } else {
                    products = data['products'];
                  }
                }

                if (mounted) setState(() {});
                _refreshController.refreshCompleted();
                setState(() {
                  refreshCount++;
                });
              },
              onLoading: () async {
                print('triggered 1');
                Map<String, dynamic>? data =
                    await reloadFromMock(pageNumber + 1)
                        as Map<String, dynamic>;

                if (data.isNotEmpty) {
                  print('adding');
                  for (Product product in data['products']) {
                    products.add(product);
                  }
                }

                pageNumber = pageNumber + 1;
                if (mounted) setState(() {});
                _refreshController.refreshCompleted();
              },
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                crossAxisCount: 3,
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  //
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/product',
                          arguments: {
                            'productNumber': products[index].productNumber
                          },
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 160,

                        child: Image(
                          image: NetworkImage(products[index].defaultImageUrl!),
                          fit: BoxFit.cover,
                          // width: 80,
                          // height: 120,
                        ),
                        // margin: EdgeInsets.all(20.0),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) {
                  /// Simple grid/cell placements
                  if (index == 1) {
                    return StaggeredTile.count(2, 2);
                  } else if (index % 9 > 0) {
                    return StaggeredTile.count(1, 1);
                  } else if (index % 6 > 0) {
                    return StaggeredTile.count(2, 2);
                  } else if (index > 12) {
                    return StaggeredTile.count(2, 2);
                  } else {
                    return StaggeredTile.count(
                      index.isOdd ? 2 : 1,
                      index.isOdd ? 2 : 1,
                    );
                  }
                },
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _loadData() async {}

  Future<Map<dynamic, dynamic>> reloadFromMock(int pageNumber) async {
    // final FlutterSecureStorage store = FlutterSecureStorage();
    var frontpageSections = await _apiResource.discover(
        query: Provider.of<AppState>(context, listen: false).query,
        pageNumber: pageNumber);
    Map<String, dynamic> results =
        ProductTransformer.collection(frontpageSections);

    return results;
  }

  Future<Map<dynamic, dynamic>?> fromMock(bool reload, String query) async {
    final FlutterSecureStorage store = FlutterSecureStorage();

    if (reload == false) {
      print('From cache');
      String? data = await store.read(key: query);

      if (data == null || data.isEmpty) {
        var frontpageSections = await _apiResource.discover(query: query);

        // print(this.frontpage_sections);
        await store.write(
          key: query,
          value: json.encode(frontpageSections),
        );

        String? data = await store.read(key: query);

        var decoded = json.decode(data!);

        assert(decoded != null);

        if (decoded != null) {
          Map<String, dynamic> results = ProductTransformer.collection(decoded);
          return results;
        }
      } else {
        var decoded = json.decode(data);

        assert(decoded != null);

        if (decoded != null) {
          Map<String, dynamic> results = ProductTransformer.collection(decoded);
          print(results['products'][0].toMap());
          return results;
        }
      }

      return null;
    } else {
      print('From api');

      await store.delete(key: query);

      var frontpageSections = await _apiResource.discover(
          query: Provider.of<AppState>(context, listen: false).query);

      // // print(this.frontpage_sections);
      await store.write(
        key: query,
        value: json.encode(frontpageSections),
      );

      String? data = await store.read(key: query);

      var decoded = json.decode(data!);

      assert(decoded != null);

      if (decoded != null) {
        Map<String, dynamic> results =
            ProductTransformer.collection(frontpageSections);
        print(results['products'][0].toMap());
        return results;
      }

      return null;
    }
  }
}

// FutureBuilder(
//             future: fromMock(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Expanded(
//                   child: StaggeredGridView.countBuilder(
//                     crossAxisCount: 3,
//                     itemCount: 10,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Shimmer.fromColors(
//                         baseColor: Colors.black12.withAlpha(50),
//                         highlightColor: Colors.black12,
//                         child: Container(
//                           width: 100,
//                           height: 160,
//                           decoration: BoxDecoration(
//                             color: Colors.black12,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                         ),
//                       );
//                     },
//                     staggeredTileBuilder: (int index) {
//                       /// Simple grid/cell algorithm
//                       if (index == 1) {
//                         return StaggeredTile.count(2, 2);
//                       } else if (index % 9 > 0) {
//                         return StaggeredTile.count(1, 1);
//                       } else if (index % 6 > 0) {
//                         return StaggeredTile.count(2, 2);
//                       } else if (index > 12) {
//                         return StaggeredTile.count(2, 2);
//                       } else {
//                         return StaggeredTile.count(
//                           index.isOdd ? 2 : 1,
//                           index.isOdd ? 2 : 1,
//                         );
//                       }
//                     },
//                     crossAxisSpacing: 10.0,
//                     mainAxisSpacing: 10.0,
//                   ),
//                 );
//               } else if (snapshot.hasError) {
//                 return Expanded(
//                   child: Center(
//                     child: Text(
//                       'Unable to load request. \n Network timedout',
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 );
//               } else {
//                 final List<Product> products = snapshot.data['products'];

//                 return Expanded(
//                   child: StaggeredGridView.countBuilder(
//                     padding: EdgeInsets.symmetric(horizontal: 6.0),
//                     crossAxisCount: 3,
//                     itemCount: products.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       //
//                       return ClipRRect(
//                         borderRadius: BorderRadius.circular(6),
//                         child: GestureDetector(
//                           onTap: () {
//                             return Navigator.of(context).pushNamed(
//                               '/product',
//                               arguments: {
//                                 'productNumber': products[index].productNumber
//                               },
//                             );
//                           },
//                           child: Container(
//                             width: 100,
//                             height: 160,

//                             child: Image(
//                               image:
//                                   NetworkImage(products[index].defaultImageUrl),
//                               fit: BoxFit.cover,
//                               // width: 80,
//                               // height: 120,
//                             ),
//                             // margin: EdgeInsets.all(20.0),
//                           ),
//                         ),
//                       );
//                     },
//                     staggeredTileBuilder: (int index) {
//                       /// Simple grid/cell placements
//                       if (index == 1) {
//                         return StaggeredTile.count(2, 2);
//                       } else if (index % 9 > 0) {
//                         return StaggeredTile.count(1, 1);
//                       } else if (index % 6 > 0) {
//                         return StaggeredTile.count(2, 2);
//                       } else if (index > 12) {
//                         return StaggeredTile.count(2, 2);
//                       } else {
//                         return StaggeredTile.count(
//                           index.isOdd ? 2 : 1,
//                           index.isOdd ? 2 : 1,
//                         );
//                       }
//                     },
//                     crossAxisSpacing: 6.0,
//                     mainAxisSpacing: 6.0,
//                   ),
//                 );
//               }
//             },
//           )
