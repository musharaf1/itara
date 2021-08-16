import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:itarashop/ui/auth/signin_screen.dart';
import 'package:provider/provider.dart';
import '../../api/FirebaseResource.dart';
import '../../app_state.dart';
import '../../common/custom_alert.dart';

class SocialButtons extends StatefulWidget {
  final FlowType flowType;
  final String? deepLinkSubCategory;
  final String? categoryTitle;
  final Function(bool)? func;

  const SocialButtons(
      {Key? key,
      this.flowType = FlowType.Normal,
      this.deepLinkSubCategory,
      this.func,
      this.categoryTitle})
      : super(key: key);
  @override
  _SocialButtonsState createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  final FirebaseResource _firebaseResource = FirebaseResource();
  bool _loading = false;

  void handleError(error) {
    // TODO: show snackBar
    setState(() {
      _loading = false;
      widget.func!(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () async {
            googleSignIn();
            // Navigator.pop(context);

            // setState(() {
            //   _loading = true;
            //   widget.func!(true);
            // });

            // _firebaseResource.googleSignIn().then((user) async {
            //   // AppState.setCurrentUser(user);
            //   if (user != null) {
            //     Provider.of<AppState>(context, listen: false)
            //         .setCurrentUser(user);

            //     Navigator.of(context).pop('dialog');

            //     // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);

            //     if (widget.flowType == FlowType.Normal) {
            //       print('here');
            //       return await Get.offNamedUntil('/app', (route) => false,
            //           arguments: {
            //             'activeScreen': 0,
            //           });
            //     } else {
            //       // Navigate to category screen
            //       return Get.offNamedUntil('/subcategory', (route) => false,
            //           arguments: {
            //             "deepLinkSubCat": widget.deepLinkSubCategory,
            //             "categoryTitle": widget.categoryTitle,
            //             "flowType": FlowType.DeepLink
            //           });
            //     }
            //   }
            // }).catchError((onError) {
            //   setState(() {
            //     widget.func!(false);
            //   });
            //   handleError(onError);
            // });
          },
          child: SvgPicture.asset('assets/images/icon-google.svg'),
        ),
        // SizedBox(width: 10),
        // InkWell(
        //   onTap: () async {
        //     // facebookSignIn();
        //     setState(() {
        //       _loading = true;
        //       widget.func!(true);
        //     });
        //     _firebaseResource.facebookSignIn().then((user) {
        //       if (user != null) {
        //         Provider.of<AppState>(context, listen: false)
        //             .setCurrentUser(user);
        //         Navigator.of(context).pop('dialog');
        //         Navigator.of(context).pushReplacementNamed('/app', arguments: {
        //           'activeScreen': 0,
        //         });
        //       }
        //     }).catchError((onError) {
        //       setState(() {
        //         widget.func!(false);
        //       });
        //       Navigator.pop(context);
        //       handleError(onError);
        //     });
        //   },
        //   child: SvgPicture.asset('assets/images/icon-facebook.svg'),
        // ),
        SizedBox(width: 10),
        InkWell(
          onTap: () async {
            twitterSignIn();
            // setState(() {
            //   _loading = true;
            //   widget.func!(true);
            // });
            // _firebaseResource.twitterSignIn().then((user) async {
            //   if (user != null) {
            //     print('Here with user: ${user.toMap()}');
            //     Provider.of<AppState>(context, listen: false)
            //         .setCurrentUser(user);
            //     Navigator.of(context).pop('dialog');
            //     await Navigator.of(context)
            //         .pushReplacementNamed('/app', arguments: {
            //       'activeScreen': 0,
            //     });
            //   }
            // }).catchError((onError) {
            //   setState(() {
            //     widget.func!(false);
            //   });
            //   handleError(onError);
            //   Navigator.pop(context);
            // });
          },
          child: SvgPicture.asset('assets/images/icon-twitter.svg'),
        )
      ],
    );
  }

  Future googleSignIn() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomAlert(
              title: '"ItaraShop" Wants to Use "gmail.com" to Sign in',
              desc: 'This allows the app to share \ninformation about you.',
              loading: _loading,
              onCancel: () {
                setState(() {
                  _loading = false;
                });
              },
              onAction: () {
                // Navigator.pop(context);

                setState(() {
                  _loading = true;
                });

                _firebaseResource.googleSignIn().then((user) async {
                  // AppState.setCurrentUser(user);
                  if (user != null) {
                    Provider.of<AppState>(context, listen: false)
                        .setCurrentUser(user);
                    Provider.of<AppState>(context, listen: false)
                        .listAddresses(notify: false);

                    Navigator.of(context).pop('dialog');

                    // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);

                    if (widget.flowType == FlowType.Normal) {
                      print('here');
                      return await Get.offNamedUntil('/app', (route) => false,
                          arguments: {
                            'activeScreen': 0,
                          });
                    } else {
                      // Navigate to category screen
                      return Get.offNamedUntil('/subcategory', (route) => false,
                          arguments: {
                            "deepLinkSubCat": widget.deepLinkSubCategory,
                            "categoryTitle": widget.categoryTitle,
                            "flowType": FlowType.DeepLink
                          });
                    }
                  }
                }).catchError((onError) {
                  setState(() {
                    _loading = false;
                  });
                  handleError(onError);
                });
              },
            );
          },
        );
      },
    );
  }

  Future facebookSignIn() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomAlert(
              title: '"ItaraShop" Wants to Use "facebook.com" to Sign in',
              desc: 'This allows the app to share \ninformation about you.',
              loading: _loading,
              onCancel: () {
                setState(() {
                  _loading = false;
                });
              },
              onAction: () {
                setState(() {
                  _loading = true;
                });
                _firebaseResource.facebookSignIn().then((user) {
                  if (user != null) {
                    Provider.of<AppState>(context, listen: false)
                        .setCurrentUser(user);
                    Provider.of<AppState>(context, listen: false)
                        .listAddresses(notify: false);
                    Navigator.of(context).pop('dialog');
                    Navigator.of(context)
                        .pushReplacementNamed('/app', arguments: {
                      'activeScreen': 0,
                    });
                  }
                }).catchError((onError) {
                  Navigator.pop(context);
                  handleError(onError);
                });
              },
            );
          },
        );
      },
    );
  }

  Future twitterSignIn() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomAlert(
              title: '"ItaraShop" Wants to Use "twitter.com" to Sign in',
              desc: 'This allows the app to share \ninformation about you.',
              loading: _loading,
              onCancel: () {
                setState(() {
                  _loading = false;
                });
              },
              onAction: () {
                setState(() {
                  _loading = true;
                });
                _firebaseResource.twitterSignIn().then((user) async {
                  if (user != null) {
                    print('Here with user: ${user.toMap()}');
                    Provider.of<AppState>(context, listen: false)
                        .setCurrentUser(user);
                    Provider.of<AppState>(context, listen: false)
                        .listAddresses(notify: false);
                    Navigator.of(context).pop('dialog');
                    await Navigator.of(context)
                        .pushReplacementNamed('/app', arguments: {
                      'activeScreen': 0,
                    });
                  }
                }).catchError((onError) {
                  handleError(onError);
                  Navigator.pop(context);
                });
              },
            );
          },
        );
      },
    );
  }
}
