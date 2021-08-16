/// Transform products resource
///
/// [payload] must not be null
/// returns [products] and [meta]

import '../model/Meta.dart';
import '../model/Product.dart';

class ProductTransformer {
  static Map<String, dynamic> collection(Map payload) {
    final data = Map<String, dynamic>();

    data['products'] = (payload['data'] as Iterable).map((json) {
      return Product.fromJson(json);
    }).toList();

    data['meta'] = Meta.fromJson({
      'page': payload["page"],
      'size': payload["size"],
      'count': payload["count"],
    });

    return data;
  }
}
