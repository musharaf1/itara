import 'package:flutter/material.dart';

class OptionsListTile extends StatelessWidget {
  final Function? onAction;
  final String? title;
  final String? trailing;
  final bool isSelected;
  final EdgeInsets? contentPadding;

  OptionsListTile({
    this.onAction,
    this.title,
    this.trailing,
    this.isSelected = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding,
      dense: true,
      onTap: () {
        onAction!();
      },
      title: Text(
        title!,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? Colors.black : Colors.black54,
            ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check,
              size: 18,
              color: Colors.black,
            )
          : SizedBox.shrink(),
    );
  }
}
