import 'package:glowguide/features/clinics/data/models/clinic_model.dart';
import 'package:glowguide/features/offers/domain/entities/get_all_offers_entities.dart';

class GetAllOfferModel extends GetAllOffersEntities {
  GetAllOfferModel({
    required super.offerID,
    required super.clinicID,
    required super.offerCategories,
    required super.offerImage,
    required super.startDate,
    required super.endDate,
    required super.isHidden,
    required super.status,
    required super.createdBy,
    required super.clinicDetails,
  });

  factory GetAllOfferModel.fromJson(Map<String, dynamic> json) {
    return GetAllOfferModel(
      offerID: json['id'] ?? '',
      clinicID: json['cid'] ?? '',
      clinicDetails: ClinicModel.fromJson(json['clinic'] ?? {}),
      offerCategories: List<String>.from(json['categories_data'] ?? []),
      offerImage: json['image'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      isHidden: json['is_hidden'] ?? false,
      status: json['status'] ?? '',
      createdBy: json['created_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': offerID,
      'cid': clinicID,
      'categories_data': offerCategories,
      'image': offerImage,
      'start_date': startDate,
      'end_date': endDate,
      'is_hidden': isHidden,
      'status': status,
      'created_by': createdBy,
    };
  }
}
