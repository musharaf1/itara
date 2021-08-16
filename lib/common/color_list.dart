import 'package:flutter/material.dart';
// import 'package:marketplace/app_theme.dart';
import '../common/color_widget.dart';
import '../model/Product.dart';

class ColorList extends StatefulWidget {
  final List<ProductColor>? colors;
  final List<dynamic>? selected;
  final Function(List color)? onSelect;

  ColorList({@required this.colors, @required this.onSelect, this.selected});

  @override
  _ColorListState createState() => _ColorListState();
}

class _ColorListState extends State<ColorList> {
  List<dynamic> _selected = [];

  @override
  Widget build(BuildContext context) {
    // Set default color range
    if (mounted) {
      _selected = (widget.selected == null ? [] : widget.selected)!;
    }

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.colors!.asMap().entries.map((color) {
          return ColorWidget(
            color: color.value.colorCode,
            selected:
                _selected != null && _selected.contains(color.value.colorCode),
            onTap: (color) {
              setState(() {
                if (_selected.contains(color)) {
                  _selected.remove(color);
                } else {
                  _selected.add(color);
                }
                widget.onSelect!(_selected);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
