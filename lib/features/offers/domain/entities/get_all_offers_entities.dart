import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';

class GetAllOffersEntities {
  final String offerID;
  final String clinicID;
  final ClinicEntity clinicDetails;
  final List offerCategories;
  final String offerImage;
  final String startDate;
  final String endDate;
  final bool isHidden;
  final String status;
  final String createdBy;

  GetAllOffersEntities({
    required this.offerID,
    required this.clinicID,
    required this.offerCategories,
    required this.offerImage,
    required this.startDate,
    required this.endDate,
    required this.isHidden,
    required this.status,
    required this.createdBy,
    required this.clinicDetails,
  });
}
