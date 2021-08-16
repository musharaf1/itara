import 'package:flutter/material.dart';

class CategoryBanner extends StatelessWidget {
  final String? name;
  final String? description;
  final String? imageUrl;
  final bool hasShare;

  CategoryBanner({
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    this.hasShare = false,
  });

  @override
  Widget build(BuildContext context) {
    assert(name != null);
    assert(description != null);
    assert(imageUrl != null);

    return Container(
      height: MediaQuery.of(context).size.width - 100,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Hero(
              tag: name!,
              child: Image(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
                color: Colors.black26,
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          Positioned(
            right: 20.0,
            left: 20.0,
            bottom: 20.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name!,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        description!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                if (hasShare)
                  GestureDetector(
                    child: Icon(Icons.share, color: Colors.white),
                    onTap: () {},
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
