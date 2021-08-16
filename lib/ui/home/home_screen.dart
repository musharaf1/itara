import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itarashop/api/Client.dart';
import 'package:itarashop/app_state.dart';
import 'package:itarashop/model/User.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../model/Frontpage.dart';
import '../../ui/home/generic_products.dart';
import '../../ui/home/home_slides.dart';

import '../../common/search_widget.dart';
import 'discover_slides.dart';
import 'latest_products.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  int refreshCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    // load();
    loadUser();
    super.initState();
  }

  Future loadUser() async {
    Client _client = Client();
    FlutterSecureStorage _store = FlutterSecureStorage();
    print('loading');
    try {
      User _user =
          await Provider.of<AppState>(context, listen: false).currentUser;
      final User refetchUser = await _client.load(User.getCurrentUser(_user));
      var mergeUserData = <String, dynamic>{};
      mergeUserData = {
        ..._user.toMap(),
        ...refetchUser.toMap(),
      };
      print(refetchUser);

      await _store.write(key: 'user', value: json.encode(mergeUserData));
      Provider.of<AppState>(context, listen: false).listAddresses(notify: false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> load() async {
    frontPage = await FrontPage.fromMock(false);
    setState(() {});
  }

  bool show = true;

  FrontPage? frontPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          centerTitle: true,
          titleSpacing: 0,
          title: SearchBar(
            withBackButton: false,
          ),
        ),
        body: Column(
          children: [
            show
                ? Container(
                    width: double.infinity,
                    // height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff2b2b2b),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'All items are ready-to-ship',
                              style: GoogleFonts.workSans(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                show = false;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullUp: false,
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
                  FrontPage? data = await FrontPage.fromMock(ref);

                  if (data!.toMap().isNotEmpty) {
                    if (refreshCount > 0) {
                      setState(() {
                        frontPage = null;
                        frontPage = data;
                      });
                    } else {
                      frontPage = data;
                    }
                  }
                  if (mounted) setState(() {});
                  _refreshController.refreshCompleted();
                  setState(() {
                    refreshCount++;
                  });
                },
                onLoading: () async {
                  print('Triggered loading');
                  // print('triggered 1');
                  //     Map<String, dynamic> data = await reloadFromMock();

                  //     if (data.isNotEmpty) {
                  //       print('adding');
                  //       for (Product product in data['products']) {
                  //         products.add(product);
                  //       }
                  //     }

                  //     if (mounted) setState(() {});
                  //     _refreshController.refreshCompleted();
                },
                child: ListView.builder(
                  itemCount: frontPage == null ? 0 : 1,
                  itemBuilder: (context, index) {
                    print(frontPage!.frontPageSections!.length);
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          HomeSlides(slides: frontPage!.headerSlides),
                          frontPage!.frontPageSections!.length > 0
                              ? frontPage!
                                      .frontPageSections![0].products!.isEmpty
                                  ? SizedBox()
                                  : LatestProducts(
                                      section: frontPage!.frontPageSections![0])
                              : SizedBox(),
                          // SizedBox(height: 20),
                          frontPage!.frontPageSections!.length > 1
                              ? frontPage!
                                      .frontPageSections![1].products!.isEmpty
                                  ? SizedBox()
                                  : GenericProducts(
                                      section: frontPage!.frontPageSections![1])
                              : SizedBox(),
                          SizedBox(height: 20),
                          frontPage!.discoverSlides!.isEmpty
                              ? SizedBox()
                              : DiscoverSlides(
                                  slides: frontPage!.discoverSlides!),
                          SizedBox(height: 20),
                          frontPage!.frontPageSections!.length > 2
                              ? frontPage!
                                      .frontPageSections![2].products!.isEmpty
                                  ? SizedBox()
                                  : GenericProducts(
                                      section: frontPage!.frontPageSections![2])
                              : SizedBox(),
                          // SizedBox(height: 20),
                          frontPage!.frontPageSections!.length > 3
                              ? frontPage!
                                      .frontPageSections![3].products!.isEmpty
                                  ? SizedBox()
                                  : GenericProducts(
                                      section: frontPage!.frontPageSections![3])
                              : SizedBox(),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

//  FutureBuilder<FrontPage>(
//         future: FrontPage.fromMock(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//                 child: ProgressbarCircular(
//               useLogo: true,
//             ));
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text('An error has occured while loading data'),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasData) {
//             final List<HeaderSlide> headerSlides = snapshot.data.headerSlides;

//             final List<FrontPageSection> frontPageSections =
//                 snapshot.data.frontPageSections;
//             final List<DiscoverSlide> discoverSlides =
//                 snapshot.data.discoverSlides;

//             // print(frontPageSections);

//             return Column(
//               children: <Widget>[
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: <Widget>[
//                         HomeSlides(slides: headerSlides),
//                         frontPageSections[0].products.isEmpty
//                             ? SizedBox()
//                             : LatestProducts(section: frontPageSections[0]),
//                         // SizedBox(height: 20),
//                         frontPageSections[1].products.isEmpty
//                             ? SizedBox()
//                             : GenericProducts(section: frontPageSections[1]),
//                         SizedBox(height: 20),
//                         discoverSlides.isEmpty
//                             ? SizedBox()
//                             : DiscoverSlides(slides: discoverSlides),
//                         SizedBox(height: 20),
//                         frontPageSections[2].products.isEmpty
//                             ? SizedBox()
//                             : GenericProducts(section: frontPageSections[2]),
//                         SizedBox(height: 20),
//                         frontPageSections[3].products.isEmpty
//                             ? SizedBox()
//                             : GenericProducts(section: frontPageSections[3]),
//                         SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return SizedBox.shrink();
//           }
//         },
//       ),
