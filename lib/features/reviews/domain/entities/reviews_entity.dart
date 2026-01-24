import 'package:glowguide/features/auth/domain/entities/login_entity.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';

class ReviewsEntity {
  final String reviewID;
  final String clinicID;
  final ClinicEntity clinicDetails;
  final String userID;
  final UserEntity userDetails;
  final int reviewRating;
  final String reviewContent;
  final String reviewStatus;

  ReviewsEntity({
    required this.reviewID,
    required this.clinicID,
    required this.clinicDetails,
    required this.userID,
    required this.userDetails,
    required this.reviewRating,
    required this.reviewContent,
    required this.reviewStatus,
  });
}
