import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/common/progressbar_linear.dart';

class Webview extends StatefulWidget {
  final String? url;
  final String? title;

  Webview({
    @required this.url,
    this.title = "Itara",
  });

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  StreamSubscription<String>? _onUrlChanged;
  StreamSubscription<WebViewStateChanged>? _onStateChanged;
  final _history = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // close any current instance
    flutterWebViewPlugin.close();

    // listen for state changes
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((viewState) async {
      if (mounted) {
        // if (viewState.type == WebViewState.finishLoad) {
        //
        // }
        // if (viewState.type == WebViewState.startLoad) {
        //   setState(() {
        //     loading = true;
        //   });
        // } else {
        //   setState(() {
        //     loading = false;
        //   });
        // }
      }
    });

    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        // handle success, show ui to user

        print(url);

        // paystack success - payments-callback.html?trxref
        //           fail   - payments-callback.html?status=cancelled
        //
        // flutter success  - maybe payments-callback.html?status=success
        //           fail   - payments-callback.html?status=cancelled
        //

        // cancelled
        if (url.contains('payments-callback.html?status=cancelled')) {
          // TODO: clear local cart
          await secureStorage.delete(key: 'cart');

          // Redirect out of webview
          // 0 - home
          // 1 - Explore
          // 2 - Cart
          // 3 - Profile
          await flutterWebViewPlugin.close();
          flutterWebViewPlugin.dispose();
          await Navigator.of(context).pushReplacementNamed(
            '/app',
            arguments: <String, int>{'activeScreen': 1},
          );
        }

        // success
        if (url.contains('payments-callback.html?trxref') ||
            url.contains('payments-callback.html?status=success')) {
          await secureStorage.delete(key: 'cart');

          await flutterWebViewPlugin.close();
          flutterWebViewPlugin.dispose();
          await Navigator.of(context).pushReplacementNamed(
            '/app',
            arguments: <String, int>{'activeScreen': 1},
          );
        }

        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged!.cancel();
    _onStateChanged!.cancel();
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          // print(message.message);
        }),
  ].toSet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title!,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        // iconTheme: IconThemeData(color: Colors.),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Divider(height: 1),
            ),
            Positioned(
              top: loading ? 10 : 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: WebviewScaffold(
                url: this.widget.url!,
                javascriptChannels: jsChannels,
                withJavascript: true,
                mediaPlaybackRequiresUserGesture: false,
                withZoom: false,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  child: Center(
                    child: ProgressbarCircular(
                      useLogo: true,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 2,
                child: ProgressbarLinear(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
