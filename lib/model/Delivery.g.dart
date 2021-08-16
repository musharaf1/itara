// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) {
  return Delivery(
    deliveryAddressId: json['deliveryAddressId'] as String,
    contactName: json['contactName'] as String,
    contactPhone: json['contactPhone'] as String,
    contactPhone2: json['contactPhone2'] as String,
    addressName: json['addressName'] as String,
    addressLine1: json['addressLine1'] as String,
    addressLine2: json['addressLine2'] as String,
    deliveryInstruction: json['deliveryInstruction'] as String,
    isDefaultDeliveryAddress: json['isDefaultDeliveryAddress'] as bool,
    city: json['city'] as Map<String, dynamic>,
    isOnIsland: json['city']['isOnIsland'] as bool
  );
}

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'deliveryAddressId': instance.deliveryAddressId,
      'contactName': instance.contactName,
      'contactPhone': instance.contactPhone,
      'contactPhone2': instance.contactPhone2,
      'addressName': instance.addressName,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'deliveryInstruction': instance.deliveryInstruction,
      'isDefaultDeliveryAddress': instance.isDefaultDeliveryAddress,
      'city': instance.city,
      'isOnIsland': instance.isOnIsland
    };
