import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:itarashop/api/Client.dart';
import '../api/Resource.dart';
import '../model/DiscoverSlide.dart';
import 'FrontPageSection.dart';
import 'HeaderSlide.dart';

class FrontPage {
  static final Client _client = Client();
  List<FrontPageSection>? frontPageSections = [];
  List<HeaderSlide>? headerSlides = [];
  List<DiscoverSlide>? discoverSlides = [];

  FrontPage({
    this.frontPageSections,
    this.headerSlides,
    this.discoverSlides,
  });

  factory FrontPage.fromJson(Map json) {
    List _frontPageSections = json['frontPageSections'];
    List _headerSlides = json['headerSlides'];
    List _discoverSlides = json['discoverSlides'];

    // assert(_frontPageSections.isNotEmpty);
    // assert(_headerSlides.isNotEmpty);
    // assert(_discoverSlides.isNotEmpty);

    return FrontPage(
      frontPageSections: _frontPageSections.map((model) {
        return FrontPageSection.fromJson(model);
      }).toList(),
      headerSlides: _headerSlides.map((model) {
        return HeaderSlide.fromJson(model);
      }).toList(),
      discoverSlides: _discoverSlides.map((model) {
        return DiscoverSlide.fromJson(model);
      }).toList(),
    );
  }

  Map toMap() {
    var data = Map<String, dynamic>();

    data['frontPageSections'] = frontPageSections!.map((payload) {
      assert(payload != null);
      return payload.toMap();
    }).toList();
    data['headerSlides'] = headerSlides!.map((payload) {
      assert(payload != null);
      return payload.toMap();
    }).toList();
    data['discoverSlides'] = discoverSlides!.map((payload) {
      assert(payload != null);

      return payload.toMap();
    }).toList();

    return data;
  }

  static Future<FrontPage?> fromMock(bool reload) async {
    final FlutterSecureStorage store = FlutterSecureStorage();

    if (reload == false) {
      String? data = await store.read(key: 'frontpage_sections');

      if (data == null || data.isEmpty) {
        FrontPage frontpageSections = await _client.load(FrontPage.all);

        // print(this.frontpage_sections);
        await store.write(
          key: 'frontpage_sections',
          value: json.encode(frontpageSections.toMap()),
        );

        String? data = await store.read(key: 'frontpage_sections');

        var decoded = json.decode(data!);

        assert(decoded != null);

        if (decoded != null) {
          FrontPage frontpage = FrontPage.fromJson(decoded);
          return frontpage;
        }
      } else {
        var decoded = json.decode(data);

        assert(decoded != null);

        if (decoded != null) {
          FrontPage frontpage = FrontPage.fromJson(decoded);
          return frontpage;
        }
      }

      return null;
    } else {
      await store.delete(key: 'frontpage_sections');

      FrontPage frontpageSections = await _client.load(FrontPage.all);

      // print(this.frontpage_sections);
      await store.write(
        key: 'frontpage_sections',
        value: json.encode(frontpageSections.toMap()),
      );

      String? data = await store.read(key: 'frontpage_sections');

      var decoded = json.decode(data!);

      assert(decoded != null);

      if (decoded != null) {
        FrontPage frontpage = FrontPage.fromJson(decoded);
        return frontpage;
      }
    }
  }

  static Resource get all {
    return Resource(
      url: 'frontpage-sections',
      parse: (response) {
        Map list = response["data"];

        return FrontPage.fromJson(list);
      },
    );
  }
}
