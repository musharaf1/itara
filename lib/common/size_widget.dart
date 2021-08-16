import 'package:flutter/material.dart';
import '../common/small_button.dart';
import '../model/ProductSize.dart';

class SizeWidget extends StatefulWidget {
  final ProductSize? productSize;
  bool? onSelected;
  final Function(ProductSize size)? onTap;

  SizeWidget({this.productSize, this.onSelected = true, this.onTap});

  @override
  _SizeWidgetState createState() => _SizeWidgetState();
}

class _SizeWidgetState extends State<SizeWidget> {
  bool? selected = true;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        selected = widget.onSelected;
      });
    });
    // print('Selected $selected');
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        height: 25.0,
        // color: Colors.black54.withAlpha(10),
        decoration: BoxDecoration(
          color: selected!
              ? Theme.of(context).colorScheme.primaryVariant
              : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),

        child: SmallButton(
          title: widget.productSize!.size!.sizeName,
          color: Colors.black38.withAlpha(10),
          // color: selected! ? Colors.black12.withAlpha(10) : Colors.white,
          textColor: selected! ? Colors.white : Colors.black87,
          borderColor: Colors.black12.withAlpha(30),
          borderRadius: 5.0,
          onTap: () {
            widget.onTap!(widget.productSize!);
          },
        ),
      ),
    );
  }
}
