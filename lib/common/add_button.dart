import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String? label;

  AddButton({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.add_circle),
        SizedBox(width: 10),
        Text(
          label!,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Theme.of(context).colorScheme.primaryVariant),
        ),
      ],
    );
  }
}
