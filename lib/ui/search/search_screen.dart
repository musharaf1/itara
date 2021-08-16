import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:itarashop/ui/category/nodata.dart';
import 'package:itarashop/ui/search/viewCat.dart';
import '../../api/ApiResource.dart';
import '../../app_theme.dart';
import '../../common/progressbar_circular.dart';
import 'search_result.dart';
import '../../model/Product.dart';

class SearchScreen extends SearchDelegate<Product> {
  final ApiResource _apiResource = ApiResource();
  final FlutterSecureStorage _store = FlutterSecureStorage();

  @override
  String get searchFieldLabel => 'Enter search...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      // appBarTheme: AppBarTheme(
      //   centerTitle: false,
      //   elevation: 
      // ),
      primaryColor: Colors.white,
      primaryColorBrightness: Brightness.light,
      primaryIconTheme: theme.primaryIconTheme.copyWith(
        color: Theme.of(context).colorScheme.primaryVariant,
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        
        contentPadding: EdgeInsets.only(left: 9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppTheme.accents['muted']!,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppTheme.accents['muted']!,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppTheme.accents['muted']!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppTheme.accents['muted']!,
          ),
        ),
        hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.black26,
            ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: (){
        close(context, Product());
      },
      child: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // perform search

    return FutureBuilder(
      future: _apiResource.searchProducts(query, {}),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // add search query to history
          saveSearch(query);

          if (snapshot.data["products"].length == 0) {
            return NoData();
            // return Container();
          }
          return SearchResult(
            result: snapshot.data['products'],
            meta: snapshot.data['meta'],
            query: query,
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Network error or timed out.'),
          );
        } else {
          return Center(
              child: ProgressbarCircular(
            useLogo: true,
          ));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewCategoryList(),
                ),
              );
            },
            title: Text(
              'Browse by Categories',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black87,
              size: 15,
            ),
          ),

          /// [Suggestions from history]
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 0, 0),
            child: Text(
              'Search history',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          StatefulBuilder(builder: (context, setState) {
            return FutureBuilder(
              future: getHistory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List items = snapshot.data as List;

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ...List.generate(items.length + 1, (int j) {
                          if (j == 0) {
                            if (items.isEmpty) return SizedBox.shrink();

                            return Padding(
                              padding: EdgeInsets.only(right: 2.0),
                              child: ListTile(
                                title: Text(
                                  'Clear All',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        // fontSize: ,
                                      ),
                                ),
                                // subtitle: Text(''),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () async {
                                    clearHistory();
                                    items = [];
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          }

                          final String history = items[j - 1];

                          return Padding(
                            padding: EdgeInsets.only(right: 2.0),
                            child: ListTile(
                              onTap: () async {
                                this.query = history;
                                this.showResults(context);
                              },
                              title: Text(
                                history,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              // subtitle: Text(''),
                              trailing: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.close),
                                onPressed: () async {
                                  clearHistoryItem(history);
                                  items.removeWhere((element) => element == history);
                                  // await buildSuggestions(context);
                                  setState((){});
                                },
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            );
          }),

          /// [Categories]
        ],
      ),
    );
  }

  // Padding(
  //                           padding: const EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
  //                           child: SmallButton(
  //                             title: history,
  //                             // icon: Icons.close,
  //                             onTap: () async {
  //                               this.query = history;
  //                               await this.showResults(context);
  //                               // await clearHistoryItem(items[j]);
  //                               // items.removeAt(j);
  //                               // setState(() {});
  //                             },
  //                           ),
  //                         );

  // SmallButton(
  //                               title: 'Clear All',
  //                               icon: Icons.close,
  //                               onTap: () async {
  //                                 // await clearHistoryItem(items[j]);
  //                                 //  items.removeAt(j);
  //                                 await clearHistory();
  //                                 items = [];
  //                                 setState(() {});
  //                               },
  //                             ),

  void clearHistory() async {
    await _store.delete(key: 'search');
  }

  void clearHistoryItem(String name) async {
    final history = await _store.read(key: 'search');
    if (history != null) {
      List _history = json.decode(history);

      _history = _history..removeWhere((e) => e == name);

      await _store.write(key: 'search', value: json.encode(_history));
    }
  }

  void saveSearch(String search) async {
    List history = await getHistory();

    history.add(search);

    await _store.write(key: 'search', value: json.encode(history));
  }

  Future<List> getHistory() async {
    List history = [];

    final payload = await _store.read(key: 'search');

    if (payload != null) {
      history = json.decode(payload);
    }

    // return unique suggestions only
    return history.reversed.toSet().toList();
  }

  Future<List?> getCategories() async {
    try {
      final doc = await _apiResource.getCategories();
      return doc;
    } catch (e) {
      return null;
    }
  }
}
