import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../common/options_list_tile.dart';
import '../model/Product.dart';
import 'options_list_tile.dart';

class FilterSortHeader extends StatefulWidget {
  final String? sortParameterSlug;
  final Function? onAction;
  final String? query;
  final bool displayGrid;
  final Function? onDisplayGrid;

  FilterSortHeader({
    this.sortParameterSlug,
    this.onAction,
    this.query,
    this.displayGrid = false,
    this.onDisplayGrid,
  });

  @override
  _FilterSortHeaderState createState() => _FilterSortHeaderState();
}

class _FilterSortHeaderState extends State<FilterSortHeader> {
  PersistentBottomSheetController? controller;

  closeBottomSheet() {
    if (mounted) {
      setState(() {
        controller = null;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () => sortAction(),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    width: 1,
                    color: Colors.black12,
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    children: <Widget>[
                      Text('Sort by'),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.iconTheme.color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: FlatButton(
                onPressed: () => filterAction(context),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    width: 1,
                    color: Colors.black12,
                  ),
                ),
                child: Text('Filter'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                onTap: () => widget.onDisplayGrid!(),
                child: SvgPicture.asset(
                  widget.displayGrid
                      ? 'assets/images/menu_list.svg'
                      : 'assets/images/menu_grid.svg',
                  color: theme.colorScheme.primaryVariant,
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     displayGrid = !displayGrid;
            //     setState(() {});
            //   },
            //   iconSize: 28,
            //   icon: displayGrid ? Icon(Icons.list) : Icon(Icons.grid_on),
            // )
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  filterAction(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/search-filter',
      arguments: {
        'query': widget.query,
      },
    );
  }

  sortAction() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          titlePadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          title: Stack(
            children: <Widget>[
              Positioned(
                right: 10.0,
                top: 0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  iconSize: 28,
                  icon: Icon(Icons.close, color: Colors.black87),
                ),
              ),
              Align(
                alignment: FractionalOffset.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                        left: 30.0,
                        bottom: 20.0,
                      ),
                      child: Text('Sort by'),
                    ),
                    Column(
                      children: Product.sortables.map(
                        (Sort sort) {
                          bool isSelected = widget.sortParameterSlug ==
                              sort.sortParameterSlug;

                          return Column(
                            children: <Widget>[
                              Divider(height: 0),
                              OptionsListTile(
                                title: sort.name,
                                isSelected: isSelected,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 30.0),
                                onAction: () {
                                  Navigator.pop(context);
                                  widget.onAction!(sort.sortParameterSlug);
                                },
                              )
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
