import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:itarashop/ui/auth/signin_screen.dart';
import 'package:uni_links/uni_links.dart';
import 'api/ApiResource.dart';
import 'app_routes.dart';
import 'app_state.dart';
import 'app_tabview.dart';
import 'app_theme.dart';
import 'ui/auth/auth_screen.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  StreamSubscription? _sub;
  final FlutterSecureStorage _store = FlutterSecureStorage();
  bool _loading = false;
  final ApiResource _apiResource = ApiResource();

  @override
  void initState() {
    super.initState();
    // initDynamicLinks();
    initDeepLinks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sub!.cancel();
    super.dispose();
  }

  String split(Uri initialUri) {
    var value = initialUri.toString().split('link=');
    var newUrl = value.last;
    var value2 = newUrl.toString().split('&');
    var newUrl2 = value2.first;
    var value3 = newUrl2.toString().split('https://itarashop.ng/');
    var newUrl3 = value3.last;
    return newUrl3;
  }

  void initDeepLinks() async {
    var _user = await _store.read(key: 'user');
    final String? token = await _store.read(key: 'token');
    try {
      Uri? initialUri = await getInitialUri();
      // print(newUrl3);

      if (initialUri != null) {
        String newUrl3 = split(initialUri);

        _sub = getUriLinksStream().listen(
          (Uri? uri) async {
            if (newUrl3.toString().contains('email')) {
              await Get.offNamedUntil('/app', (route) => false, arguments: {
                'activeScreen': 0,
              });
            } else if (newUrl3.toString().contains('password')) {
              await Get.offNamed('/signin', arguments: {});
            } else if (newUrl3.toString().contains('category')) {
              List newList = newUrl3.toString().split('/');
              String query = newList.last;
              // Map<String, dynamic> params = uri.queryParameters;
              if (_user != null && token != null) {
                //get category params and push to subcategory route
                await Get.offNamed('/subcategory', arguments: {
                  "deepLinkSubCat": query,
                  "categoryTitle": query,
                  "flowType": FlowType.DeepLink
                });
              } else if (_user == null || token == null) {
                // Navigate to auth screen
                await Get.offNamed('/signin', arguments: {
                  "deepLinkSubCategory": query,
                  "categoryTitle": query,
                  "flowType": FlowType.DeepLink
                });
              }
            } else if (newUrl3.contains('product')) {
              List newList = newUrl3.toString().split('/');
              String query = newList.last;

              if (_user != null && token != null) {
                await Get.offNamed('/product',
                    arguments: {'productNumber': query});
              } else if (_user == null || token == null) {
                await Get.offNamed('/product',
                    arguments: {'productNumber': query});
              }
            } else if (newUrl3.contains('tag')) {
              List newList = newUrl3.toString().split('/');
              String query = newList.last;

              await Get.offNamed('/tags', arguments: {
                "deepLinkSubCat": query,
                "categoryTitle": query,
                "flowType": FlowType.DeepLink
              });

              // navigate to tag product screen
            }
          },
          onError: (err) {
            print(err);
          },
        );
      }
    } on FormatException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: Text('Error Launching App')),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            title: 'ItaraShop',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: SplashScreen(),
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder: (BuildContext context) => generateRoute(
                  context: context,
                  name: settings.name,
                  arguments: settings.arguments as Map<String, dynamic>,
                ),
              );
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // init state and fetch dependencies
    Provider.of<AppState>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<AppState>(
        builder: (context, appstate, child) {
          if (appstate.initialising) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Image.asset(
                    'assets/images/splash.png',
                    height: 35,
                  ),
                )),
              ),
            );
          }

          if (!appstate.onBoarded) {
            return OnBoardingScreen();
          }

          if (appstate.isAuthenticated) {
            return AppTabView();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}

// boolean isLoggedIn = accessToken != null && !accessToken.isExpired();
//
// git push https://feolixa@gitlab.com/itara/itarashop-hybrid-mobile-app-2.git dev
