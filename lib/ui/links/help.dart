import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String? appVersionBuild;
  final List<String> links = [
    "About us",
    "How to shop",
    "Frequently asked questions",
    "Become a partner",
    "App Version",
    "last"
  ];

  @override
  void initState() {
    // TODO: implement initState
    generateText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Help', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
      ),
      body: Column(
        children: [
          Divider(
            height: 1.0,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: links.length,
              itemBuilder: (context, int i) {
                final String slug = links[i].replaceAll(' ', '-').toLowerCase();
                if (links[i] == "App Version") {
                  return ListTile(
                    title: Text(
                      'App Version',
                      style: theme.subtitle2,
                    ),
                    trailing: Text(appVersionBuild ?? ''),
                  );
                }

                if (links[i] == 'last') {
                  return SizedBox();
                  // return Container(
                  //   height: 100,
                  //   color: Colors.black38,
                  //   width: double.infinity,
                  // );

                }

                return ListTile(
                  title: Text(
                    links[i],
                    style: theme.subtitle2,
                  ),
                  onTap: () async {
                    final String uri = 'https://itarashop.ng/$slug';

                    await canLaunch(uri)
                        ? await launch(
                            uri,
                            forceSafariVC: true,
                            forceWebView: true,
                            enableJavaScript: true,
                          )
                        : await launch(
                            uri,
                            forceSafariVC: true,
                            forceWebView: true,
                            enableJavaScript: true,
                          );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1.0);
              },
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

  Future<String> generateText() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      appVersionBuild = '$appVersion+$buildNumber';
    });

    return '$appVersion +$buildNumber';
  }
}

// String appName = packageInfo.appName;
// String packageName = packageInfo.packageName;
// String version = packageInfo.version;
// String buildNumber = packageInfo.buildNumber;
