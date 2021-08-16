import 'package:flutter/material.dart';
import 'package:itarashop/api/err.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalScreen extends StatelessWidget {
  final List<String> links = ["Privacy Policy", "Terms of Service"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Legal', style: Theme.of(context).textTheme.headline6!.copyWith(
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
        ],
      ),
    );
  }
}
