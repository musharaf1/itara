import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itarashop/ui/auth/signin_screen.dart';
import '../../ui/category/category_banner.dart';
import '../../model/Category.dart';
import '../../common/search_widget.dart';

class CategoryScreen2 extends StatelessWidget {
  final Category? category;

  CategoryScreen2({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        centerTitle: true,
        titleSpacing: 0,
        title: SearchBar(
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                '/subcategory',
                arguments: {
                  'categoryTitle': category!.name,
                  'subcategory': category,
                  'flowType': FlowType.Normal
                },
              ),
              child: CategoryBanner(
                name: category!.name,
                description: category!.description,
                imageUrl: category!.imageUrl,
                hasShare: true,
              ),
            ),
            buildGridView(context),
          ],
        ),
      ),
    );
  }

  GridView buildGridView(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(20.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20.0,
      mainAxisSpacing: 20.0,
      childAspectRatio: 1.0,
      children: category!.subCategories!.map((item) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    '/subcategory',
                    arguments: {
                      'categoryTitle': category!.name!,
                      'subcategory': item,
                      'flowType': FlowType.Normal
                    },
                  ),
                  child: Hero(
                    tag: item.name!,
                    child: Image(
                      width: 100,
                      height: 100,
                      image: NetworkImage(item.imageUrl!),
                      color: Colors.black26,
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
                child: Text(
                  item.name!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ),
              // Positioned(
              //   right: 16.0,
              //   top: 16.0,
              //   child: SvgPicture.asset('assets/images/link-transparent.svg'),
              // )
            ],
          ),
        );
      }).toList(),
    );
  }
}
