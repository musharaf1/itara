import 'package:flutter/material.dart';
// import '../../common/small_button.dart';

class SearchSuggestion extends StatefulWidget {
  final List? suggestions;
  final Function? onClearSuggestion;
  final Function(String suggestion)? onClickSuggestion;

  SearchSuggestion({
    this.suggestions,
    this.onClearSuggestion,
    this.onClickSuggestion,
  });

  @override
  _SearchSuggestionState createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  List? _suggestions;

  @override
  void initState() {
    _suggestions = widget.suggestions;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
      child: ListView.builder(
        itemCount: _suggestions!.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return (_suggestions!.isNotEmpty)
                ? ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Categories',
                              style: Theme.of(context).textTheme.title,
                            ),

                            // show recent searches

                            // SmallButton(
                            //   title: 'Clean',
                            //   icon: Icons.close,
                            //   onTap: () {
                            //     _suggestions = [];
                            //     widget.onClearSuggestion();
                            //     setState(() {});
                            //   },
                            // )
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          }

          final String name = widget.suggestions![index - 1];

          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Divider()
              ],
            ),
            onTap: () {
              widget.onClickSuggestion!(name);
            },
          );
        },
      ),
    );
  }
}
