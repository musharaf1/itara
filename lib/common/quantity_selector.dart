import 'package:flutter/material.dart';
import 'package:itarashop/api/err.dart';
import 'package:itarashop/model/Product.dart';

class QuantitySelector extends StatefulWidget {
  final int value;
  final Product? product;
  final int max;
  final Function(int value)? onChange;

  QuantitySelector({
    this.value = 1,
    this.max = 10,
    this.onChange,
    this.product,
  });

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int? _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              if (_value! > 1) {
                _value = _value! - 1;
              }

              widget.onChange!(_value!);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black54,
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(Icons.remove, size: 14, color: Color(0xFF5c5c5c)),
          ),
        ),
        SizedBox(
          width: 24,
          child: Text(
            _value.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Color(0xFF5c5c5c)),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.product!.inventory!.name!.toLowerCase() ==
                'single piece') {
              if (_value! < 1) {
                setState(() {
                  if (_value == widget.max) {
                    ShowErrors.showErrors(
                        'Only ${widget.max} piece(s) of this product is available');
                  } else {
                    _value = _value! + 1;

                    widget.onChange!(_value!);
                  }
                });
              } else {
                ShowErrors.showErrors(
                    'You can add only 1 single piece product');
              }
            } else if (widget.product!.inventory!.name!.toLowerCase() ==
                'limited quantity') {
              if (_value! < 2) {
                setState(() {
                  if (_value == widget.max) {
                    ShowErrors.showErrors(
                        'Only ${widget.max} piece(s) of this product is available');
                  } else {
                    _value = _value! + 1;

                    widget.onChange!(_value!);
                  }
                });
              } else {
                ShowErrors.showErrors(
                    'You can add only 2 limited quantity products');
              }
            } else if (widget.product!.inventory!.name!.toLowerCase() ==
                'mass produced') {
              if (_value! < 3) {
                setState(() {
                  if (_value == widget.max) {
                    ShowErrors.showErrors(
                        'Only ${widget.max} piece(s) of this product is available');
                  } else {
                    _value = _value! + 1;

                    widget.onChange!(_value!);
                  }
                });
              } else {
                ShowErrors.showErrors(
                    'You can add only 3 plenty-stock products');
              }
            } else {
              setState(() {
                if (_value == widget.max) {
                  ShowErrors.showErrors(
                      'Only ${widget.max} piece(s) of this product is available');
                } else {
                  _value = _value! + 1;

                  widget.onChange!(_value!);
                }
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryVariant,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(Icons.add, size: 14, color: Colors.white),
          ),
        )
      ],
    );
  }
}
