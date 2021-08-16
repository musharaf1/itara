class StoreOwner {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? profilePictureUrl;
  String? gender;
  bool? isAdmin = false;
  bool? isPartner = false;
  String? timeCreated;

  StoreOwner({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.gender,
    this.isAdmin,
    this.isPartner,
    this.timeCreated,
  });

  factory StoreOwner.fromJson(Map json) {
    return StoreOwner(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePictureUrl: json['profilePictureUrl'],
      gender: json['gender'],
      isAdmin: json['isAdmin'],
      isPartner: json['isPartner'],
      timeCreated: json['timeCreated'],
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['profilePictureUrl'] = profilePictureUrl;
    data['gender'] = gender;
    data['isAdmin'] = isAdmin;
    data['isPartner'] = isPartner;
    data['timeCreated'] = timeCreated;

    return data;
  }
}

class Store {
  String? storeSlug;
  String? name;
  String? imageUrl;
  double? rating;
  StoreOwner? storeOwner;

  Store({
    this.storeSlug,
    this.name,
    this.imageUrl,
    this.rating,
    this.storeOwner,
  });

  factory Store.fromJson(Map json) {
    return Store(
      storeSlug: json['storeSlug'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      rating: json['rating'],
      storeOwner: json['storeOwner'] != null
          ? StoreOwner.fromJson(json['storeOwner'])
          : null,
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['storeSlug'] = storeSlug;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['rating'] = rating;
    data['storeOwner'] = storeOwner!.toMap();

    return data;
  }
}
