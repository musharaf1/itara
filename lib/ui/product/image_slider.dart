import 'package:flutter/material.dart';
import '../../common/slide_indicator.dart';

class ImageSlides extends StatefulWidget {
  final List? slides;
  final bool isFrontPageView;

  ImageSlides({
    this.slides,
    this.isFrontPageView = false,
  });

  @override
  _ImageSlidesState createState() => _ImageSlidesState();
}

class _ImageSlidesState extends State<ImageSlides> {
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
          height: 300,
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
              final String slide = widget.slides![index];
              return Image(
                image: NetworkImage(slide),
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
        if (widget.isFrontPageView)
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 65,
            child: Text(
              widget.slides![currentPage],
              maxLines: 2,
              style: t.textTheme.headline5!.copyWith(color: Colors.white),
            ),
          ),
        Positioned(
          left: 20.0,
          right: 20.0,
          bottom: 16.0,
          child: Row(
            mainAxisAlignment: widget.isFrontPageView
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (widget.isFrontPageView)
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      '/frontsection-slug',
                      arguments: {'slug': widget.slides![currentPage]}),
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
                currentIndex: currentPage,
                pageCount: widget.slides!.length,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
