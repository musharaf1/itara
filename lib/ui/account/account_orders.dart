import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/product_order.dart';
import 'package:itarashop/common/shimmers/product_cart_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class AccountOrders extends StatefulWidget {
  final String? userId;
  // final Map wishlist;

  const AccountOrders({@required this.userId});

  @override
  _AccountOrdersState createState() => _AccountOrdersState();
}

class _AccountOrdersState extends State<AccountOrders> {
  ApiResource? _apiResource;

  List items = [];
  bool loading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _apiResource = ApiResource();
    fetch();
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  Future<void> fetch() async {
    try {
      this.setState(() {
        loading = true;
        error = false;
      });
      final docs = await _apiResource!.orders(
        userId: widget.userId!,
      );

      this.setState(() {
        items = List.from(docs['data']);
        loading = false;
      });

      print(docs);
    } catch (e) {
      this.setState(() {
        error = true;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Orders', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primaryVariant,
            indicatorWeight: 2.0,
            labelColor: Colors.black,
            labelStyle: Theme.of(context).textTheme.headline6,
            labelPadding: EdgeInsets.only(top: 10.0),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Pending',
                icon: Icon(
                  Icons.cake,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),
              Tab(
                text: 'Completed',
                icon: Icon(
                  Icons.radio,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
              padding: EdgeInsets.all(20),
              itemCount: items.isNotEmpty ? items.length : 1,
              separatorBuilder: (context, int index) {
                return Divider();
              },
              itemBuilder: (context, int index) {
                if (items.isEmpty) {
                  if (loading) {
                    return ProductCartShimmer();
                  } else {
                    return Center(
                      child: Text('No product orders'),
                    );
                  }
                } else {
                  final item = items[index];
                  // print(item);

                  return item['status'] != 'completed'
                      ? ProductOrder(
                          item: item,
                        )
                      : SizedBox.shrink();
                  // return Container(
                  //   height: 80,
                  //   child: Text('Item placeholder'),
                  // );
                }
              },
            ),
            ListView.separated(
              padding: EdgeInsets.all(20),
              itemCount: items.isNotEmpty ? items.length : 1,
              separatorBuilder: (context, int index) {
                return Divider();
              },
              itemBuilder: (context, int index) {
                if (items.isEmpty) {
                  if (loading) {
                    return ProductCartShimmer();
                  } else {
                    return Center(
                      child: Text('No product orders'),
                    );
                  }
                } else {
                  final item = items[index];
                  // print(item);

                  return item['status'] == 'completed'
                      ? ProductOrder(
                          item: item,
                        )
                      : SizedBox.shrink();
                  // return Container(
                  //   height: 80,
                  //   child: Text('Item placeholder'),
                  // );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Column(
//         children: [
//           Divider(height: 1.0),
//           Expanded(
//             child: ListView.separated(
//               padding: EdgeInsets.all(20),
//               itemCount: items.isNotEmpty ? items.length : 4,
//               separatorBuilder: (context, int index) {
//                 return Divider();
//               },
//               itemBuilder: (context, int index) {
//                 if (items.isEmpty) {
//                   if (loading) {
//                     return ProductCartShimmer();
//                   } else {
//                     Center(
//                       child: Text('No product orders'),
//                     );
//                   }
//                 }

//                 final item = items[index];
//                 // print(item);

//                 return ProductOrder(
//                   item: item,
//                 );
//                 // return Container(
//                 //   height: 80,
//                 //   child: Text('Item placeholder'),
//                 // );
//               },
//             ),
//           ),
//         ],
//       ),

class TabBarViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade500,
          title: Text('TabBar Widget', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
          bottom: TabBar(
            indicatorColor: Colors.lime,
            indicatorWeight: 5.0,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.only(top: 10.0),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Cake',
                icon: Icon(
                  Icons.cake,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),
              //child: Image.asset('images/android.png'),

              Tab(
                text: 'Radio',
                icon: Icon(
                  Icons.radio,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),
              Tab(
                text: 'Gift',
                icon: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
                child: Text(
              'This is Cake Tab',
              style: TextStyle(fontSize: 32),
            )),
            Center(
                child: Text(
              'This is Radio Tab',
              style: TextStyle(fontSize: 32),
            )),
            Center(
                child: Text(
              'This is Gift Tab',
              style: TextStyle(fontSize: 32),
            )),
          ],
        ),
      ),
    );
  }
}
