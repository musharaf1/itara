import 'package:flutter/material.dart';
import '../../model/DiscoverSlide.dart';
import '../../common/slide_indicator.dart';

class DiscoverSlides extends StatefulWidget {
  final List<DiscoverSlide>? slides;

  DiscoverSlides({this.slides});

  @override
  _DiscoverSlidesState createState() => _DiscoverSlidesState();
}

class _DiscoverSlidesState extends State<DiscoverSlides> {
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
              DiscoverSlide slide = widget.slides![index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/product',
                    arguments: {'productNumber': widget.slides![index].productNumber},
                  );
                },
                child: Container(
                  child: Image(
                    image: NetworkImage(slide.defaultImageUrl!),
                    color: Colors.black.withOpacity(0.2),
                    colorBlendMode: BlendMode.darken,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.slides![currentPage].name!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: t.textTheme.headline5!.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  // TODO: uncomment category
                  // Text(
                  //   widget.slides[currentPage].category.name,
                  //   textAlign: TextAlign.center,
                  //   maxLines: 1,
                  //   style: t.textTheme.body2.copyWith(
                  //       color: Colors.white, fontWeight: FontWeight.w400),
                  // ),
                ],
              ),
            ),
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
                  'slug':
                      'discover-${widget.slides![currentPage].category!.categorySlug}',
                }),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Discover',
                      style:
                          t.textTheme.bodyText1!.copyWith(color: Colors.white),
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
