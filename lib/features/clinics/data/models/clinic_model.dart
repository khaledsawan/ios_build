import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';

class ClinicModel extends ClinicEntity {
  ClinicModel({
    required super.clinicId,
    required super.clinicName,
    required super.clinicDescription,
    required super.clinicLocation,
    required super.clinicPhoneNumber,
    required super.clinicEmail,
    required super.clinicCategories,
    required super.clinicLogoUrl,
    required super.clinicAverageRating,
    required super.clinicRatingCount,
    required super.clinicStatus,
    required super.clinicOwnerId,
    required super.clinicWhoAreWe,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      clinicId: json["id"] ?? "",
      clinicName: json["name"] ?? "",
      clinicDescription: json["description"] ?? "",
      clinicLocation: json["clocation"] ?? "",
      clinicPhoneNumber: json["phone_number"] ?? "",
      clinicEmail: json["email"] ?? "",
      clinicCategories: (json["categories_data"] as List? ?? [])
          .map((cat) => CategoryModel.fromJson(cat))
          .toList(),
      clinicLogoUrl: json["clinic_logo"] ?? "",
      clinicAverageRating: (json["average_rating"] ?? 0).toInt(),
      clinicRatingCount: (json["review_count"] ?? 0).toInt(),
      clinicStatus: json["status"] ?? "",
      clinicOwnerId: json["created_by"] ?? "",
      clinicWhoAreWe: json["who_are_we"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": clinicId,
      "name": clinicName,
      "description": clinicDescription,
      "clocation": clinicLocation,
      "phone_number": clinicPhoneNumber,
      "email": clinicEmail,
      "categories_data": clinicCategories
          .map((cat) => CategoryModel(code: cat.code, name: cat.name).toJson())
          .toList(),

      "clinic_logo": clinicLogoUrl,
      "average_rating": clinicAverageRating,
      "review_count": clinicRatingCount,
      "status": clinicStatus,
      "created_by": clinicOwnerId,
      "who_are_we": clinicWhoAreWe,
    };
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({required super.code, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(code: json['code'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name};
  }
}
