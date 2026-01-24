import 'package:hive/hive.dart';

part 'clinic_hive_model.g.dart';

@HiveType(typeId: 1)
class ClinicHiveModel extends HiveObject {
  @HiveField(0)
  final String clinicId;

  @HiveField(1)
  final String clinicName;

  @HiveField(2)
  final String clinicLogoUrl;

  @HiveField(3)
  final String clinicDescription;

  @HiveField(4)
  final String clinicLocation;

  @HiveField(5)
  final double clinicAverageRating;

  @HiveField(6)
  final int clinicRatingCount;

  ClinicHiveModel({
    required this.clinicId,
    required this.clinicName,
    required this.clinicLogoUrl,
    required this.clinicDescription,
    required this.clinicLocation,
    required this.clinicAverageRating,
    required this.clinicRatingCount,
  });
}
