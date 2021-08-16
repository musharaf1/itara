import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/api/err.dart';
import 'package:itarashop/app_state.dart';
import 'package:itarashop/common/button_widget.dart';
import 'package:itarashop/common/custom_alert.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/common/wishListList.dart';
import 'package:itarashop/common/wishlist_dialog.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class AccountWishlists extends StatefulWidget {
  final String? userId;

  AccountWishlists({@required this.userId});

  @override
  _AccountWishlistsState createState() => _AccountWishlistsState();
}

class _AccountWishlistsState extends State<AccountWishlists> {
  ApiResource? _apiResource;
  ScrollController? _scrollController;
  bool loading = false;
  bool error = false;
  List wishlists = [];

  @override
  void initState() {
    super.initState();
    _apiResource = ApiResource();
    _scrollController = ScrollController();
    fetchWishlists();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  Future<void> fetchWishlists() async {
    try {
      this.setState(() {
        loading = true;
        error = false;
      });

      final docs = await _apiResource!.getWishlist(userId: widget.userId!);

      setState(() {
        wishlists = List.from(docs['data']);
        loading = false;
      });
      print(wishlists);
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

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Wishlists', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 8.0, left: 10, right: 10),
      //   child: GestureDetector(
      //     onTap: () async {
      //       final appstate = await Provider.of<AppState>(
      //         context,
      //         listen: false,
      //       );

      //       if (appstate.isAuthenticated) {
      //         return showDialog(
      //           context: context,
      //           builder: (context) => WishListList(
      //             userId: appstate.authenticatedUser!.id,
      //             productNumber: 'hbdjnas8a9',
      //             onTap: (bool status) {
      //               this.setState(() {
      //                 // isInWishlist = status;
      //               });
      //             },
      //           ),
      //         );
      //       } else {
      //         //TODO: Add sign in popup
      //         ShowErrors.showErrors('You have to Login first');
      //         print("Pop up to sign in");
      //       }
      //     },
      //     child: Button(
      //       gradient: 'colored',
      //       label: 'CREATE A WISHLIST',
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          Divider(height: 1.0),
          if (loading == true && wishlists.isEmpty)
            Expanded(
              child: Center(
                child: ProgressbarCircular(
                  useLogo: true,
                ),
              ),
            )
          else if (loading == false && wishlists.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Text(
                      'You have no wishlist.',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Create a wishlist and add products you love.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () async {
                          final appstate = await Provider.of<AppState>(
                            context,
                            listen: false,
                          );

                          if (appstate.isAuthenticated) {
                            return showDialog(
                              context: context,
                              builder: (context) => WishListList(
                                userId: appstate.authenticatedUser!.id,
                                productNumber: 'hbdjnas8a9',
                                onTap: (bool status) {
                                  this.setState(() {
                                    // isInWishlist = status;
                                  });
                                },
                              ),
                            );
                          } else {
                            //TODO: Add sign in popup
                            ShowErrors.showErrors('You have to Login first');
                            print("Pop up to sign in");
                          }
                        },
                        child: Button(
                          gradient: 'colored',
                          label: 'CREATE A WISHLIST',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: wishlists.length + 1,
                separatorBuilder: (context, int index) {
                  return Divider();
                },
                itemBuilder: (context, int index) {
                  if (index == (wishlists.length)) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () async {
                          final appstate = await Provider.of<AppState>(
                            context,
                            listen: false,
                          );

                          if (appstate.isAuthenticated) {
                            return showDialog(
                              context: context,
                              builder: (context) => WishListList(
                                userId: appstate.authenticatedUser!.id,
                                productNumber: 'hbdjnas8a9',
                                onTap: (bool status) {
                                  this.setState(() {
                                    // isInWishlist = status;
                                  });
                                },
                              ),
                            );
                          } else {
                            //TODO: Add sign in popup
                            ShowErrors.showErrors('You have to Login first');
                            print("Pop up to sign in");
                          }
                        },
                        child: Button(
                          gradient: 'colored',
                          label: 'CREATE A WISHLIST',
                        ),
                      ),
                    );
                  } else {
                    final wishlist = wishlists[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/account/wishlists/items',
                            arguments: {
                              'userId': widget.userId,
                              'wishlist': wishlist,
                            });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 6,
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 4 / 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: NetworkImage(wishlist['imageUrl']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${wishlist['name']}',
                                    style: textTheme.headline6,
                                  ),
                                  SizedBox(height: 1.5),
                                  Text(
                                    '${wishlist['totalWishListItems']} items',
                                    style: textTheme.subtitle2!.copyWith(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  if (!wishlist['isPublic'])
                                    Icon(
                                      Icons.lock,
                                      color: Colors.grey.shade400,
                                      size: 16,
                                    ),
                                  DeleteButton(
                                    name: wishlist['wishListSlug'],
                                    onTap: () {
                                      wishlists.removeAt(index);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 0, 20),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade400,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  const DeleteButton({Key? key, this.name, this.onTap}) : super(key: key);
  final String? name;
  final GestureTapCallback? onTap;

  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  ApiResource _apiResource = ApiResource();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading == true
        ? SizedBox(
            height: 15,
            width: 15,
            child: ProgressbarCircular(),
          )
        : GestureDetector(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return CustomAlert(
                        title: 'Confirm Action',
                        desc: 'Are you sure you want to delete this wishlist?',
                        loading: loading,
                        onAction: () async {
                          setState(() {
                            loading = true;
                          });
                          await _apiResource.deleteWishlists(
                              userId:
                                  Provider.of<AppState>(context, listen: false)
                                      .authenticatedUser!
                                      .id!,
                              wishListSlug: widget.name!);
                          widget.onTap!();
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                        },
                      );
                    });
                  });
            },
            child: Container(
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(text: 'DELETE'),
                  ],
                ),
              ),
            ),
          );
  }
}
