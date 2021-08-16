import 'package:flutter/material.dart';
import '../../common/product_grid.dart';
import '../../common/headline_link.dart';
import '../../model/FrontPageSection.dart';

class GenericProducts extends StatelessWidget {
  final FrontPageSection? section;

  GenericProducts({this.section});

  @override
  Widget build(BuildContext context) {
    if (section == null || section!.products!.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeadlineLink(
          title: section!.name,
          onTap: () {
            Navigator.of(context).pushNamed(
              '/frontsection-slug',
              arguments: {'slug': section!.frontPageSectionSlug},
            );
          },
        ),
        SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: section!.products!.asMap().entries.map((item) {
              return Padding(
                padding: item.key == 0
                    ? EdgeInsets.only(left: 20.0, right: 12.0)
                    : EdgeInsets.only(right: 12.0),
                child: ProductGrid(product: item.value),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
