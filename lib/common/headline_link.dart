import 'package:flutter/material.dart';

class HeadlineLink extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Function? onTap;
  final bool show;

  HeadlineLink({this.title, this.onTap, this.subtitle, this.show = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (title != null)
            Text(
              title!,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w700,
                    // fontSize: 22.0,
                    color: Colors.black,
                  ),
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
            ),
         show ? FittedBox(
            child: GestureDetector(
              onTap: () => onTap!(),
              child: Row(
                children: <Widget>[
                  Text('All'),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ) : SizedBox()
        ],
      ),
    );
  }
}
