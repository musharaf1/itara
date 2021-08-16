import 'package:flutter/material.dart';
import 'package:itarashop/model/Meta.dart';
import 'package:itarashop/model/Product.dart';
import '../../api/ApiResource.dart';
import '../../common/product_gridview.dart';
import '../../common/progressbar_circular.dart';
import 'package:recase/recase.dart';

class FrontSectionSlugScreen extends StatefulWidget {
  final String? slug;
  final bool latest;

  FrontSectionSlugScreen({required this.slug, this.latest = false});

  @override
  _FrontSectionSlugScreenState createState() => _FrontSectionSlugScreenState();
}

class _FrontSectionSlugScreenState extends State<FrontSectionSlugScreen> {
  final ApiResource _apiResource = ApiResource();

  @override
  void initState() {
    // TODO: implement initState
    getProducts();
    super.initState();
  }

  bool loading = false;

  List<Product> products = [];
  Meta meta = Meta();

  Future getProducts() async {
    setState(() {
      loading = true;
    });
    Map<dynamic, dynamic> data =
        await _apiResource.frontpageProducts(widget.slug!);

    setState(() {
      loading = false;
    });
    if (data['products'].isNotEmpty) {
      setState(() {
        products = data['products'];
        meta = data['meta'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          ReCase(widget.slug!).titleCase,
         style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: loading == true
          ? Center(
              child: ProgressbarCircular(useLogo: true),
            )
          : Column(
              children: [
                ProductGridView(
                  result: products,
                  meta: meta,
                  fetchMore: () async {
                    print('triggered');
                    await _apiResource
                        .frontpageProducts(widget.slug!,
                            pageNumber: meta.page! + 1)
                        .then(
                      (result) {
                        setState(
                          () {
                            products..addAll(result['products']);
                            meta = result['meta'];
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
