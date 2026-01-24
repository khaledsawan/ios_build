import 'package:glowguide/features/reviews/domain/entities/write_review_entity.dart';

class WriteReviewModel extends WriteReviewEntity {
  WriteReviewModel();

  factory WriteReviewModel.fromJson(Map<String, dynamic> json) {
    return WriteReviewModel();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
