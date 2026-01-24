import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';

abstract class ReviewsClinicIDStates {}

class ReviewsClinicIDInitial extends ReviewsClinicIDStates {}

class GetAllReviewsByClinicIDLoading extends ReviewsClinicIDStates {}

class GetAllReviewsByClinicIDSuccessfully extends ReviewsClinicIDStates {
  final List<ReviewsEntity> reviews;

  GetAllReviewsByClinicIDSuccessfully({required this.reviews});
}

class GetAllReviewsByClinicIDFailed extends ReviewsClinicIDStates {
  final String errMessage;

  GetAllReviewsByClinicIDFailed({required this.errMessage});
}
