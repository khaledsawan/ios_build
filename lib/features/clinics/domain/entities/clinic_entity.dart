class ClinicEntity {
  final String clinicId;
  final String clinicName;
  final String clinicDescription;
  final String clinicWhoAreWe;
  final String clinicLocation;
  final String clinicPhoneNumber;
  final String clinicEmail;
  final List<CategoryEntity> clinicCategories;
  final String clinicLogoUrl;
  final int clinicAverageRating;
  final int clinicRatingCount;
  final String clinicStatus;
  final String clinicOwnerId;

  ClinicEntity({
    required this.clinicId,
    required this.clinicName,
    required this.clinicDescription,
    required this.clinicLocation,
    required this.clinicPhoneNumber,
    required this.clinicEmail,
    required this.clinicCategories,
    required this.clinicLogoUrl,
    required this.clinicAverageRating,
    required this.clinicRatingCount,
    required this.clinicStatus,
    required this.clinicOwnerId,
    required this.clinicWhoAreWe,
  });
}

class CategoryEntity {
  final String code;
  final String name;

  CategoryEntity({required this.code, required this.name});
}
