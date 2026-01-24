import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';

abstract class ReviewsStates {}

class ReviewsInitial extends ReviewsStates {}

class WriteReviewLoading extends ReviewsStates {}

class WriteReviewSuccessfully extends ReviewsStates {}

class WriteReviewFailed extends ReviewsStates {
  final String errMessage;

  WriteReviewFailed({required this.errMessage});
}

class GetAllReviewsLoading extends ReviewsStates {}

class GetAllReviewsSuccessfully extends ReviewsStates {
  final List<ReviewsEntity> reviews;

  GetAllReviewsSuccessfully({required this.reviews});
}

class GetAllReviewsFailed extends ReviewsStates {
  final String errMessage;

  GetAllReviewsFailed({required this.errMessage});
}

class AdmingApproveRejectReviewLoading extends ReviewsStates {}

class AdmingApproveRejectReviewSuccess extends ReviewsStates {}

class AdmingApproveRejectReviewFailed extends ReviewsStates {
  final String errMessage;

  AdmingApproveRejectReviewFailed({required this.errMessage});
}
