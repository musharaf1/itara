import 'package:flutter/material.dart';
import '../ui/search/search_screen.dart';
import '../app_theme.dart';

class SearchBar extends StatelessWidget {
  final bool withBackButton;

  SearchBar({this.withBackButton = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(context: context, delegate: SearchScreen());
      },
      child: Container(
        margin: withBackButton
            ? EdgeInsets.only(right: 20.0)
            : EdgeInsets.symmetric(horizontal: 20.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: AppTheme.accents['muted'],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                'Search keyword or product code...',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ],
        ),
      ),
    );
  }
}
