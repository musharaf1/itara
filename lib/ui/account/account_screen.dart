import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/api/Client.dart';
import 'package:itarashop/common/custom_alert.dart';
import 'package:itarashop/model/User.dart';
import 'package:itarashop/ui/account/push.dart';
import 'package:provider/provider.dart';
import '../../common/profile_top_menu.dart';
import '../../common/button_widget.dart';
import '../../common/profile_meta.dart';
import '../../app_state.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // loadUser();
    super.initState();
  }

  Client _client = Client();
  FlutterSecureStorage _store = FlutterSecureStorage();

  // Future loadUser() async {
  //   print('loading');
  //   try {
  //     // User _user = await Provider.of<AppState>(context).currentUser;
  //     var user = await _store.read(key: 'user');
  //     if (user != null) {
  //       User _user = User.fromJson(json.decode(user));
  //       print(_user);
  //       final User refetchUser = await _client.load(User.getCurrentUser(_user));
  //       var mergeUserData = <String, dynamic>{};
  //       mergeUserData = {
  //         ..._user.toMap(),
  //         ...refetchUser.toMap(),
  //       };
  //       print(refetchUser);

  //       await _store.write(key: 'user', value: json.encode(mergeUserData));
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Account', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, child) {
          if (appState.isAuthenticated) {
            return Authenticated(appState: appState);
          } else {
            return UnAuthenticated();
          }
        },
      ),
    );
  }
}

class Authenticated extends StatelessWidget {
  final AppState? appState;

  Authenticated({@required this.appState});

  final List options = [
    'Account Details',
    'Reviews',
    'Push Notifications',
    'Report a Problem',
    'Legal',
    'Help',
    // 'Delete Account',
    'Log out'
  ];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: <Widget>[
          Divider(height: 1.0),
          ProfileMeta(user: appState!.authenticatedUser),
          ProfileTopMenu(
            userId: appState!.authenticatedUser!.id,
          ),
          Divider(height: 10.0),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final String option = options[index];
              final String slug = option.replaceAll(' ', '-').toLowerCase();

              return ListTile(
                onTap: () async {
                  if (['Legal', 'Help'].contains(option)) {
                    print("open route links");

                    await Navigator.of(context).pushNamed('/links/$slug');
                    return;
                  } else if (['Log out', 'Delete Account'].contains(option)) {
                    /// [logout]
                    if (slug == "log-out") {
                      final ApiResource _apiResource = ApiResource();

                      await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return CustomAlert(
                              title: 'Confirm log out',
                              desc:
                                  'This will delete all your unsaved sessions',
                              loading: loading,
                              onAction: () async {
                                setState(() {
                                  loading = true;
                                });

                                try {
                                  await _apiResource.logout(
                                      refreshToken: appState!
                                          .authenticatedUser!.refreshToken);

                                  Provider.of<AppState>(context, listen: false)
                                      .signout();

                                  await Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                    '/auth',
                                    (_) => false,
                                  );
                                } catch (e) {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                            );
                          });
                        },
                      );
                    }
                    return;
                  } else {
                    // open nav

                    await Navigator.pushNamed(context, '/account/$slug');

                    print('open nav $slug');
                  }
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                dense: true,
                title: Text(
                  option,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 16.0,
                      ),
                ),
                trailing: option.contains('Push Notification')
                    ? Switch(
                        activeColor:
                            Theme.of(context).colorScheme.primaryVariant,
                        value: appState!.enablePushNotification,
                        onChanged: (val) async {
                          Provider.of<AppState>(context, listen: false)
                              .updatePushNotification();
                        })
                    : Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black12,
                        size: 18.0,
                      ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(height: 1.0);
            },
            itemCount: options.length,
          ),
        ],
      ),
    );
  }
}

class UnAuthenticated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You are not signed in',
              style: Theme.of(context).textTheme.body2,
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/signin');
              },
              child: Button(
                label: 'Sign In',
                gradient: 'colored',
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: Button(
                label: 'New user? Get Started',
              ),
            )
          ],
        ),
      ),
    );
  }
}
