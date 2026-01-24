import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/reviews/domain/repos/reviews_repository.dart';
import 'package:dartz/dartz.dart';

class AdminGetAllReviewsUsecase {
  final ReviewsRepository repository;

  AdminGetAllReviewsUsecase({required this.repository});

  Future<Either<Failure, List<ReviewsEntity>>> call() {
    return repository.adminGetReviews();
  }
}
