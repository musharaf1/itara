import 'dart:convert';

import 'package:itarashop/api/Resource.dart';

class Tags {
  String? id;
  String? name;
  Tags({
    this.id,
    this.name,
  });

  Tags copyWith({
    String? id,
    String? name,
  }) {
    return Tags(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Tags.fromMap(Map<String, dynamic> map) {
    return Tags(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tags.fromJson(String source) => Tags.fromMap(json.decode(source));

  @override
  String toString() => 'Tags(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tags &&
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  static Resource getTags() {
    return Resource(
      url: 'tags',
      parse: (response) {
        return response;
      },
    );
  }
}
