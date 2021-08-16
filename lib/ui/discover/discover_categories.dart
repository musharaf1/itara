import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:itarashop/model/tags.dart';
import 'package:itarashop/ui/discover/showDiscoverSearch.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../api/ApiResource.dart';
import '../../common/small_button.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverCategories extends StatefulWidget {
  final VoidCallback? callback;
  final bool? refresh;

  const DiscoverCategories({Key? key, this.callback, @required this.refresh})
      : super(key: key);
  @override
  _DiscoverCategoriesState createState() => _DiscoverCategoriesState();
}

class _DiscoverCategoriesState extends State<DiscoverCategories> {
  final ApiResource _apiResource = ApiResource();
  Future? fetchDiscoveries;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  int refreshCount = 0;

  @override
  void initState() {
    print('refresh');
    super.initState();
    fetchDiscoveries = fetch(widget.refresh!);
  }

  Future<List?> fetch(bool reload) async {
    FlutterSecureStorage _storage = FlutterSecureStorage();
    if (reload == false) {
      String? cacheTags = await _storage.read(key: "discover-tags");
      if (cacheTags == null || cacheTags.isEmpty) {
        List<Tags> tags = await _apiResource.getTags();
        _storage.write(key: 'discover-tags', value: json.encode(tags));
        List? result =
            json.decode((await _storage.read(key: 'discover-tags'))!);
        return result;
      } else {
        return json.decode(cacheTags);
      }
    } else {
      _storage.delete(key: 'discover-tags');
      List<Tags> tags = await _apiResource.getTags();
      _storage.write(key: 'discover-tags', value: json.encode(tags));
      List result = json.decode((await _storage.read(key: 'discover-tags'))!);
      print(result);
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: fetch(widget.refresh!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.black12.withAlpha(10),
            highlightColor: Colors.black12,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  final bool lastIndex = index == 5;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      20.0,
                      16.0,
                      lastIndex ? 20.0 : 0,
                      16.0,
                    ),
                    child: Container(
                      width: 100.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Network timeout'),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data!.asMap().entries.map((item) {
                final bool lastIndex = item.key == snapshot.data!.length - 1;
                Tags tags = Tags.fromJson(item.value);
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.0,
                    8.0,
                    lastIndex ? 20.0 : 0,
                    8.0,
                  ),
                  child: SmallButton(
                    title: tags.name,
                    color: Colors.transparent,
                    textColor: Colors.black87,
                    borderColor: Colors.black12,
                    borderRadius: 6.0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowDiscoverSearch(
                            query: tags.name!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
