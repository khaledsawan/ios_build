import 'package:glowguide/features/auth/data/models/login_model.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/clinics/data/models/clinic_model.dart';

class ReviewsModel extends ReviewsEntity {
  ReviewsModel({
    required super.reviewID,
    required super.clinicID,
    required super.clinicDetails,
    required super.userID,
    required super.userDetails,
    required super.reviewRating,
    required super.reviewContent,
    required super.reviewStatus,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) {
    return ReviewsModel(
      reviewID: json["id"] ?? "",
      clinicID: json["cid"] ?? "",
      clinicDetails: ClinicModel.fromJson(json["clinic"] ?? {}),

      userID: json["uid"] ?? "",
      userDetails: UserModel.fromJson(json["user"] ?? {}),

      reviewRating: (json["rating"] ?? 0).toInt(),
      reviewContent: json["text"] ?? "",
      reviewStatus: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": reviewID,
      "clinic_id": clinicID,
      "clinic_details": (clinicDetails as ClinicModel).toJson(),
      "user_id": userID,
      "user_details": (userDetails as UserModel).toJson(),
      "rating": reviewRating,
      "content": reviewContent,
      "status": reviewStatus,
    };
  }
}
