import 'package:flutter/material.dart';

import '../../app_theme.dart';

class AuthHeader extends StatelessWidget {
  final String? headline;
  final String? subhead;

  AuthHeader({this.headline, this.subhead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: theme.colorScheme.primary,
      pinned: true,
      expandedHeight: size.height * 0.2,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints contraints) {
          final double top = contraints.biggest.height;
          final barHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

          if (top <= barHeight) {
            return FlexibleSpaceBar(
              title: Text(headline!),
            );
          }

          return FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.gradients["colored-inverse"],
              ),
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    headline!,
                    style: theme.textTheme.headline5!.copyWith(
                        // fontFamily: "Roboto",
                        ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    subhead!,
                    style: theme.textTheme.bodyText2!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
