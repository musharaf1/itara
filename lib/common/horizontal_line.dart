import 'package:flutter/material.dart';

class HorizontalOrLine extends StatelessWidget {
  const HorizontalOrLine({
    this.label,
    this.height,
  });

  final String? label;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Colors.black26,
              height: height,
            )),
      ),
      Text(
        label!,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.black26,
              height: height,
            )),
      ),
    ]);
  }
}
