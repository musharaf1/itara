import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:shimmer/shimmer.dart';
import '../common/progressbar_linear.dart';

class WishListList extends StatefulWidget {
  final String? userId;
  final String? productNumber;
  final Function(bool status)? onTap;

  WishListList({
    @required this.userId,
    @required this.productNumber,
    @required this.onTap,
  });

  @override
  _WishListListState createState() => _WishListListState();
}

class _WishListListState extends State<WishListList> {
  ApiResource? _apiResource;
  FlutterSecureStorage? _flutterSecureStorage;
  ScrollController? _scrollController;
  FocusNode? _focusNode;

  bool isEditing = false;
  bool loading = false;
  bool initialising = true;
  String? selected;
  bool hasError = false;
  List wishlists = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _flutterSecureStorage = FlutterSecureStorage();
    _apiResource = ApiResource();

    _focusNode!.addListener(() {
      Future.delayed(Duration(milliseconds: 300), () {
        if (_scrollController!.hasClients) {
          _scrollController!.animateTo(
            _scrollController!.position.maxScrollExtent,
            duration: Duration(
              milliseconds: 100,
            ),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    });

    getWishlists();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    _focusNode!.dispose();
    super.dispose();
  }

  Future<void> getWishlists() async {
    try {
      final docs = await _apiResource!.getWishlist(userId: widget.userId!);
      // print(docs);
      wishlists = docs['data'] as List;

      // check if selected from local store wishlists
      final String? _storeWishlists =
          await _flutterSecureStorage!.read(key: 'wishlists');
      if (_storeWishlists != null) {
        final String wishlist = List.from(json.decode(_storeWishlists))
            .firstWhere((e) => e.split("##").last == widget.productNumber);

        if (wishlist != null && wishlist.contains("##")) {
          selected = wishlist.split("##").first;
        }
      }

      this.setState(() {
        initialising = false;
      });
    } catch (e) {
      // print(e);
      this.setState(() {
        hasError = true;
        initialising = false;
      });
    }
  }

  Future<void> createWishlist(String value) async {
    try {
      setState(() {
        loading = true;
      });

      await _apiResource!.createWishlist(
        userId: widget.userId!,
        name: value,
      );

      wishlists = wishlists
        ..add({
          'wishListSlug': value.toLowerCase().replaceAll(" ", '-'),
          'name': value,
        });

      setState(() {
        loading = false;
        // controller.text = '';
        controller.clear();
      });
    } catch (e) {
      // print(e);
      this.setState(() {
        loading = false;
      });
    }
  }

  Future<void> addToWishlist() async {
    this.setState(() {
      loading = true;
      isEditing = false;
    });

    try {
      // await _flutterSecureStorage.delete(key: 'wishlists');
      // return;

      // track productNumber in local wishlists store
      List _wishlists = [];
      String? _storeWishlists =
          await _flutterSecureStorage!.read(key: 'wishlists');
      if (_storeWishlists != null) {
        _wishlists = json.decode(_storeWishlists);

        // cleanup first to avoid duplicates
        _wishlists = _wishlists
          ..removeWhere(
            (element) => element.contains(widget.productNumber),
          );
      }

      await _apiResource!.addWishlist(
        wishListSlug: selected!,
        productNumber: widget.productNumber!,
        userId: widget.userId!,
      );

      // @add/modify wishlist in local store
      // @regex wishListSlug##ProductNumber
      _wishlists = _wishlists..add('${selected}##${widget.productNumber}');
      // print(_wishlists);
      await _flutterSecureStorage!.write(
        key: 'wishlists',
        value: json.encode(_wishlists),
      );

      this.setState(() {
        loading = false;
      });

      widget.onTap!(true);

      Navigator.pop(context, 'dialog');
    } catch (e) {
      // print(e);
      this.setState(() {
        loading = false;
      });
    }
  }

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('This is the text' + controller.text);
    return LayoutBuilder(builder: (
      context,
      constraints,
    ) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add to Wishlist',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop('dialog');
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 20.0),
                  shrinkWrap: true,
                  itemCount: initialising ? 3 : wishlists.length + 2,
                  separatorBuilder: (context, int index) {
                    return Divider();
                  },
                  itemBuilder: (context, int index) {
                    if (index == 0) {
                      return Container(); // empty divider hack
                    }

                    /// [No Items]
                    if (wishlists.isEmpty && initialising) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.grey.shade300,
                              child: Icon(Icons.circle),
                            ),
                            SizedBox(width: 10),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.grey.shade300,
                              child: Container(
                                height: 8,
                                width: constraints.minWidth * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    /// [Create new btn]
                    if (index == wishlists.length + 1) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: isEditing ? 0 : 8,
                        ),
                        child: isEditing
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller,
                                      focusNode: _focusNode,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      decoration: InputDecoration(
                                        suffixIcon: loading && isEditing
                                            ? ProgressbarCircular()
                                            : null,
                                        suffixIconConstraints: BoxConstraints(
                                          maxHeight: 24,
                                          maxWidth: 24,
                                        ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: 'Enter a new list name',
                                      ),
                                      onFieldSubmitted: (value) async {
                                        // Create wishlist
                                        if (value.characters.isEmpty) return;
                                        // controller.clear();
                                        return await createWishlist(value);
                                      },
                                    ),
                                  ),
                                  loading && !isEditing
                                      ? SizedBox(
                                          height: 2,
                                          child: ProgressbarLinear(),
                                        )
                                      : IconButton(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryVariant,
                                          onPressed: () async {
                                            if (controller.text.isEmpty) {
                                            } else {
                                              print('This is it');
                                              await createWishlist(
                                                  controller.text);
                                            }
                                          },
                                          icon: Icon(Icons.done),
                                        )
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  isEditing = true;
                                  loading = false;
                                  selected = null;
                                  this.setState(() {});
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.add_circle),
                                    SizedBox(width: 10),
                                    Text(
                                      'Create a new',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                      );
                    }

                    /// [Items]
                    final wishlist = wishlists[index - 1];
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        // selected = wishlist['wishListSlug'];
                        // this.setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${wishlist['name']}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  // Text(
                                  //   '${wishlist['totalWishListItems']} items',
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .body1
                                  //       .copyWith(
                                  //         color: Colors.grey.shade500,
                                  //       ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (loading && !isEditing)
                SizedBox(
                  height: 2,
                  child: ProgressbarLinear(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.all(10.0),
                      shape: BorderDirectional(
                        top: BorderSide(color: Colors.black12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop('dialog');
                      },
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Close',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: FlatButton(
                  //     padding: EdgeInsets.all(10.0),
                  //     shape: BorderDirectional(
                  //       top: BorderSide(color: Colors.black12),
                  //       start: BorderSide(color: Colors.black12),
                  //     ),
                  //     onPressed: () =>
                  //         selected == null ? null : addToWishlist(),
                  //     child: Opacity(
                  //       opacity: selected == null ? 0.4 : 1,
                  //       child: SizedBox(
                  //         height: 40,
                  //         child: Center(
                  //           child: Text(
                  //             'Add to list',
                  //             style: Theme.of(context).textTheme.body2.copyWith(
                  //                   color: Theme.of(context)
                  //                       .colorScheme
                  //                       .primaryVariant,
                  //                 ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
