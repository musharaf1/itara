import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html_view;
import 'package:flutter_html/style.dart' as html_style;
import 'package:itarashop/utils/utils.dart';

// import 'package:marketplace/ui/product/product_info.dart';
import '../../model/Accordion.dart';
import '../../interface/expansion_panel.dart' as custom;

class ProductAccordion extends StatefulWidget {
  final List<Accordion>? items;

  ProductAccordion({@required this.items});

  @override
  _ProjectAccordionState createState() => _ProjectAccordionState();
}

class _ProjectAccordionState extends State<ProductAccordion> {
  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    final textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    final titleStyle = textTheme.bodyText1!.copyWith(
      fontWeight: FontWeight.bold,
    );

    return custom.ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.items![index].isExpanded = !isExpanded;
        });
      },
      children: widget.items!.map<custom.ExpansionPanel>((Accordion item) {
        // print(item.body);
        // print(item);
        return custom.ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(
              item.title!,
              style: titleStyle,
            );
          },
          // body: Text('data').build(context));
          // body: item.body != null ? Container(
          //   width: double.maxFinite,
          //   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
          //   child: Text(item.body!),
          // ) : SizedBox.shrink(),

          body: item.body != null
              ? Container(
                  // constraints: BoxConstraints.tightForFinite(),
                  width: double.maxFinite,
                  padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                  child: html_view.Html(
                    style: {
                      "*": html_style.Style(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        fontFamily: t.textTheme.bodyText2!.fontFamily,
                        fontStyle: FontStyle.normal,
                        fontSize: html_style.FontSize(14),
                        color: Colors.black.withOpacity(0.6),
                        // height: 1.3
                      ),
                      "p": html_style.Style(
                        fontSize: html_style.FontSize(14),
                      ),
                    },
                    data: item.body,

                    // customRender: {
                    //   "p": (context, Widget child) {
                    //     return Text(
                    //       removeAllHtmlTags(item.body),
                    //       // context.parser.htmlData.toString(),
                    //       textWidthBasis: TextWidthBasis.parent,
                    //       style: t.textTheme.bodyText2!.copyWith(
                    //         fontStyle: FontStyle.normal,
                    //         fontSize: 14,
                    //         height: 1.3,
                    //         fontFamily: "WorkSans",
                    //         color: Colors.black.withOpacity(0.60),
                    //       ),
                    //     );
                    //   }
                    // },
                    // style: {
                    //   "p": html_style.Style(
                    //     fontSize: html_style.FontSize(10),
                    //   ),
                    // },
                  ).build(context),
                )
              : SizedBox.shrink(),
          isExpanded: item.isExpanded!,
          // value: item.index,
        );
      }).toList(),
    );
  }
}
