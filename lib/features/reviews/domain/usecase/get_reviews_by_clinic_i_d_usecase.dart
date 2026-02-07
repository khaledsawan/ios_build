import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/reviews/domain/repos/reviews_repository.dart';
import 'package:dartz/dartz.dart';

class GetReviewsByClinicIDUsecase {
  final ReviewsRepository repository;

  GetReviewsByClinicIDUsecase({required this.repository});

  Future<Either<Failure, List<ReviewsEntity>>> call({
    required GetReviewsByClinicIDParams params,
  }) {
    return repository.getReviewsByClinicID(params: params);
  }
}
