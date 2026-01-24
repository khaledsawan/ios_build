import 'package:glowguide/features/locations/domain/entities/location_entity.dart';

class LocationsModel extends LocationEntity {
  LocationsModel({
    required super.userID,
    required super.label,
    required super.floor,
    required super.address,
    required super.flat,
    required super.isDefault,
    required super.phoneNumber,
    required super.locationID,
  });

  factory LocationsModel.fromJson(Map<String, dynamic> json) {
    return LocationsModel(
      userID: json["uid"] ?? "",
      label: json["label"] ?? "",
      floor: json["floor"] ?? "",
      address: json["address"] ?? "",
      flat: json["flat"] ?? "",
      isDefault: json["is_default"] ?? false,
      phoneNumber: json["phone_number"] ?? "Unknown Phone Number",
      locationID: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": userID,
      "label": label,
      "floor": floor,
      "address": address,
      "flat": flat,
      "is_default": isDefault,
      "phone_number": phoneNumber,
      "id": locationID,
    };
  }
}
