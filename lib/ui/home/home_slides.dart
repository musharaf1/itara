import 'package:flutter/material.dart';
import '../../model/HeaderSlide.dart';
import '../../common/slide_indicator.dart';
import '../../model/Category.dart';

class HomeSlides extends StatefulWidget {
  final List<HeaderSlide>? slides;

  HomeSlides({this.slides});

  @override
  _HomeSlidesState createState() => _HomeSlidesState();
}

class _HomeSlidesState extends State<HomeSlides> {
  int currentPage = 0;
  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    if (widget.slides!.isEmpty) return SizedBox.shrink();

    return Stack(
      children: <Widget>[
        Container(
          color: Colors.black.withOpacity(0.1),
          height: MediaQuery.of(context).size.height * 0.4,
          child: PageView.builder(
            controller: _pageController,
            physics: ClampingScrollPhysics(),
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            itemCount: widget.slides!.length,
            itemBuilder: (context, int index) {
              HeaderSlide slide = widget.slides![index];
              return Image(
                image: NetworkImage(slide.imageUrl!),
                color: Colors.black.withOpacity(0.1),
                colorBlendMode: BlendMode.darken,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Container(
          color: Colors.black26,
        ),
        Positioned(
          left: 20.0,
          right: 20.0,
          bottom: 45,
          child: Text(
            widget.slides![currentPage].name!,
            maxLines: 2,
            style: t.textTheme.headline5!.copyWith(color: Colors.white),
          ),
        ),
        Positioned(
          left: 20.0,
          right: 20.0,
          bottom: 16.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed('/frontsection-slug', arguments: {
                  'slug': widget.slides![currentPage].categorySlug
                }),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Explore',
                      style: t.textTheme.bodyText1!.copyWith(color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              SlideIndicator(
                  currentIndex: currentPage, pageCount: widget.slides!.length),
            ],
          ),
        ),
      ],
    );
  }
}
