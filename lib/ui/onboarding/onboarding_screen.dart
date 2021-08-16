import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/Onboarding.dart';

import 'page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  final FlutterSecureStorage _store = FlutterSecureStorage();
  int currentIndex = 0;
  AnimationController? _controller;
  Animation<double>? _headlineAnim;
  Animation<double>? _dividerAnim;
  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _dividerAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Interval(0, 0.3)),
    );
    _headlineAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Interval(0.3, 0.8)),
    );

    _controller!.addListener(() {
      setState(() {});
    });

    _controller!.forward();

    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    physics: ClampingScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() {
                        currentIndex = page;
                        _controller!.reset();
                        _controller!.forward();
                      });
                    },
                    children: Onboarding.all.map((data) {
                      return Image(
                        image: AssetImage(
                          data.image!,
                        ),
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight * 1 / 4,
                  left: 30,
                  right: 30,
                  child: Column(
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(0.0, 30 * (1 - _dividerAnim!.value)),
                        child: Opacity(
                          opacity: _dividerAnim!.value,
                          child: Divider(
                            color: Colors.white,
                            endIndent: constraints.maxWidth * 0.2,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0.0, 20 * (1 - _headlineAnim!.value)),
                        child: Opacity(
                          opacity: _headlineAnim!.value,
                          child: Text(
                            Onboarding.all[currentIndex].headline!,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: PageIndicator(
                    currentIndex: currentIndex,
                    pageCount: Onboarding.all.length,
                  ),
                ),
                buildHeader(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Positioned(
      top: 40.0,
      right: -1.0,
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        onPressed: () async {
          await _store.write(key: 'boarded', value: 'boarded');
          Navigator.pushReplacementNamed(context, '/auth');
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.0, color: Colors.white),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(35.0),
          ),
        ),
        child: Text(
          currentIndex == 2 ? 'Enter' : 'Skip',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }
}
