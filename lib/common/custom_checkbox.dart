import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final Function(bool value)? onChanged;
  final String label;

  CustomCheckBox({
    this.isChecked = false,
    @required this.onChanged,
    this.label = "add label",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Checkbox(
            value: isChecked,
            activeColor: Theme.of(context).colorScheme.primary,
            checkColor: Colors.white,
            onChanged: (value) {
              value != null ? this.onChanged!(value) : {};
              // run background task
            },
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // visualDensity: VisualDensity.compact,
          ),
        ),
        SizedBox(width: 12),
        Text(label),
      ],
    );
  }
}
