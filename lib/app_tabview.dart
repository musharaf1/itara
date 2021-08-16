import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:itarashop/api/Client.dart';
import 'package:itarashop/app_state.dart';
import 'package:provider/provider.dart';

import 'common/apptab.dart';
import 'model/User.dart';
import 'ui/home/home_screen.dart';
import 'ui/account/account_screen.dart';
import 'ui/cart/cart_screen.dart';
import 'ui/discover/discover_screen.dart';

class AppTabView extends StatefulWidget {
  final int? activeScreen;

  AppTabView({this.activeScreen});
  @override
  _AppTabViewState createState() => _AppTabViewState();
}

class _AppTabViewState extends State<AppTabView> {
  int _activeScreen = 0;

  @override
  void initState() {
    // TODO: implement initState
    // loadUser();
    // Provider.of<AppState>(context, listen: false).listAddresses();
    super.initState();
  }

  Client _client = Client();
  FlutterSecureStorage _store = FlutterSecureStorage();

  Future loadUser() async {
    print('loading');
    try {
      User _user = await Provider.of<AppState>(context).currentUser;
      final User refetchUser = await _client.load(User.getCurrentUser(_user));
      var mergeUserData = <String, dynamic>{};
      mergeUserData = {
        ..._user.toMap(),
        ...refetchUser.toMap(),
      };
      print(refetchUser);

      await _store.write(key: 'user', value: json.encode(mergeUserData));
    } catch (e) {
      print(e);
    }
  }

  final List<String> items = [
    'assets/images/home.svg',
    'assets/images/explore.svg',
    'assets/images/cart.svg',
    'assets/images/account.svg',
  ];

  final List<Widget> screens = [
    HomeScreen(),
    DiscoverScreen(),
    CartScreen(centerTitle: true),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_activeScreen],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.asMap().entries.map((item) {
            return AppTab(
              screen: _activeScreen,
              icon: item.value,
              isActive: _activeScreen == item.key,
              onTap: () {
                setState(() {
                  _activeScreen = item.key;
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
