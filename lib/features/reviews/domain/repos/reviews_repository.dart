import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/reviews/data/models/reviews_model.dart';
import 'package:glowguide/features/reviews/domain/entities/admin_approve_reject_review_entity.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/reviews/domain/entities/write_review_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, List<ReviewsEntity>>> getAllReviews();

  Future<Either<Failure, WriteReviewEntity>> writeReiew({
    required WriteReviewParams params,
  });

  Future<Either<Failure, AdminApproveRejectReviewEntity>>
  adimnApproveRejecrReview({required AdminApproveRejectReviewParams params});

  Future<Either<Failure, List<ReviewsEntity>>> adminGetReviews();

  Future<Either<Failure, List<ReviewsModel>>> getReviewsByClinicID({
    required GetReviewsByClinicIDParams params,
  });

  Future<Either<Failure, ClinicEntity>> getClinicByID({
    required GetClinicByIDParams params,
  });
}
