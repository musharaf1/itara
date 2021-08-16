import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/common/search_widget.dart';
import 'package:itarashop/model/Category.dart';
import 'package:itarashop/model/Inventory.dart';

import 'inventoryProducts.dart';

class ViewCategoryList extends StatelessWidget {
  final List<Category>? category;
  ViewCategoryList({Key? key, this.category}) : super(key: key);
  final ApiResource _apiResource = ApiResource();
  final FlutterSecureStorage _store = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          centerTitle: true,
          titleSpacing: 0,
          title: Text(
            'View by Category/Inventory',
           style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // color: Colors.red,
              height: 200,
              child: FutureBuilder(
                future: getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching categories'),
                    );
                  }

                  if (snapshot.hasData) {
                    final categories = snapshot.data;

                    return ListView.separated(
                      itemCount: (categories as List).length + 1,
                      separatorBuilder: (context, int i) {
                        return Divider(height: 1.0);
                      },
                      itemBuilder: (context, int i) {
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 2, 0, 2),
                            child: Text(
                              'Categories',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        final Category category = categories[i - 1];

                        return GestureDetector(
                          onTap: () {
                            // this.close(context, null);

                            Navigator.pushReplacementNamed(context, '/category',
                                arguments: {
                                  'category': category,
                                });
                          },
                          child: ListTile(
                              title: Text(
                            '${category.name}',
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontWeight: FontWeight.w200,
                                    ),
                          )),
                        );
                      },
                    );
                  }

                  return Center(
                    child: ProgressbarCircular(
                      useLogo: true,
                    ),
                  );
                },
              ),
            ),
            // SizedBox(height: 10),
            Divider(
              height: 1,
            ),
            SizedBox(height: 15),
            Container(
              // color: Colors.black,
              height: 200,
              child: FutureBuilder(
                future: getInventory(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching Inventories'),
                    );
                  }

                  if (snapshot.hasData) {
                    final inventories = snapshot.data;

                    return ListView.separated(
                      itemCount: (inventories as List).length + 1,
                      separatorBuilder: (context, int i) {
                        return Divider(height: 1.0);
                      },
                      itemBuilder: (context, int i) {
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 8, 0, 8),
                            child: Text(
                              'View by Inventory',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        final Inventory inventory = inventories[i - 1];

                        return ListTile(
                          onTap: () async {
                            String invent = inventory.name == 'Single Piece'
                                ? 'single-piece'
                                : inventory.name == 'Limited Quantity'
                                    ? 'limited-quantity'
                                    : 'mass-produced';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InventoryProducts(
                                  inventory: invent,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            '${inventory.name}',
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontWeight: FontWeight.w200,
                                    ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await Get.defaultDialog(
                                title: 'Information',
                                titleStyle:
                                    Theme.of(context).textTheme.headline6,
                                content: Text(
                                  generateText(inventory.name!.toLowerCase()),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.info,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(
                    child: ProgressbarCircular(
                      useLogo: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Future<List?> getCategories() async {
    try {
      final doc = await _apiResource.getCategories();
      return doc;
    } catch (e) {
      return null;
    }
  }

  String generateText(String inventory) {
    switch (inventory) {
      case 'single piece':
        return 'All single piece products are produced in one copy only (1 of 1). If it’s bought, it may not return to the app. We recommend you to purchase as you see it. ';
        break;
      case 'limited quantity':
        return 'Limited quantity products are produced in limited quantities. They are also available for a specific period. If it’s bought, it may not return to the app. We recommend you to purchase as you see it. ';
        break;
      case 'mass produced':
        return 'These products will always be replenished/restocked until the brand decides to discontinue the product.';
        break;
      default:
        return 'This inventory type tells you more about the availability of the products.';
        break;
    }
  }

  Future<List?> getInventory() async {
    try {
      final doc = await _apiResource.getInventories();
      return doc;
    } catch (e) {
      return null;
    }
  }
}
