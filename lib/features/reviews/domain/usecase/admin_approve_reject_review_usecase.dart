import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/reviews/domain/entities/admin_approve_reject_review_entity.dart';
import 'package:glowguide/features/reviews/domain/repos/reviews_repository.dart';
import 'package:dartz/dartz.dart';

class AdminApproveRejectReviewUsecase {
  final ReviewsRepository repository;

  AdminApproveRejectReviewUsecase({required this.repository});

  Future<Either<Failure, AdminApproveRejectReviewEntity>> call({
    required AdminApproveRejectReviewParams params,
  }) {
    return repository.adimnApproveRejecrReview(params: params);
  }
}
