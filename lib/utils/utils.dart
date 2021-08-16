import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

import 'package:intl/intl.dart';

String removeAllHtmlTags(htmlText) {
  // print(htmlText.text);
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

String slugify(String char) {
  return char.replaceAll(' ', '-').toLowerCase();
}

String ucword(String char) {
  return char.substring(0, 1).toUpperCase() + char.substring(1);
}

String formatHiddenFields(MapEntry field) {
  return ["Address Book", "Password"].contains(field.key) ? field.value : "";
}

Future<String> base64ImageFromPath(String path, dynamic file) async {
  final String filename = path.split('/').last;
  final String ext = filename.split('.').last;
  final String base64Image =
      "data:image/$ext;base64," + base64Encode(await file.readAsBytes());
  return base64Image;
}

double parseDouble(String str) {
  str = str.replaceAll(',', '');

  final double? _str = double.tryParse(str);
  return _str!;
}

String toPrice(dynamic str) {
  if (str.runtimeType == String) {
    str = parseDouble(str);
  }

  return NumberFormat.simpleCurrency(
    locale: 'en_US',
    name: 'NGN',
    decimalDigits: 2,
  ).format(str);
}
