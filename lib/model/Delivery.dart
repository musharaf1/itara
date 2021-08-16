import 'package:itarashop/api/Resource.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Delivery.g.dart';

@JsonSerializable()
class Delivery {
  String? deliveryAddressId;
  String? contactName;
  String? contactPhone;
  String? contactPhone2;
  String? addressName;
  String? addressLine1;
  String? addressLine2;
  String? deliveryInstruction;
  bool? isDefaultDeliveryAddress;
  Map? city;
  bool? isOnIsland;

  Delivery({
    this.deliveryAddressId,
    this.contactName,
    this.contactPhone,
    this.contactPhone2,
    this.addressName,
    this.addressLine1,
    this.addressLine2,
    this.deliveryInstruction,
    this.isDefaultDeliveryAddress,
    this.city,
    this.isOnIsland
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => _$DeliveryFromJson(json);
  Map toMap() => _$DeliveryToJson(this);

  static Resource list(String userId) {
    print(userId);

    return Resource(
      url: 'delivery-addresses',
      data: {'userId': userId},
      parse: (response) {
        return (response['data'] as Iterable)
            .map((json) => Delivery.fromJson(json))
            .toList();
      },
    );
  }
}
