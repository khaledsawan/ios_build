import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/clinics/data/models/clinic_model.dart';
import 'package:glowguide/features/reviews/data/models/admin_approve_reject_review_model.dart';
import 'package:glowguide/features/reviews/data/models/reviews_model.dart';
import 'package:glowguide/features/reviews/data/models/write_review_model.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:dio/dio.dart';

class ReviewsRemoteDataSource {
  final ApiConsumer api;

  ReviewsRemoteDataSource({required this.api});

  Future<WriteReviewModel> writeReview(WriteReviewParams params) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);
    final response = await api.post(
      EndPoints.writeReview,
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
      data: {
        "cid": params.clinicID,
        "rating": params.rating,
        "text": params.reviewText,
      },
    );
    return WriteReviewModel.fromJson(response);
  }

  Future<List<ReviewsModel>> getAllReviews() async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);

    final response = await api.get(
      EndPoints.getAllReviews,
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
    );

    final List data = response as List;

    final reviews = data.map((json) => ReviewsModel.fromJson(json)).toList();

    return reviews;
  }

  Future<List<ReviewsModel>> getReviewsByClinicID({
    required GetReviewsByClinicIDParams params,
  }) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);

    final response = await api.get(
      "${EndPoints.getReviewsByClinicID}${params.clinicID}",
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
    );

    final List data = response as List;

    return data.map((json) => ReviewsModel.fromJson(json)).toList();
  }

  Future<AdminApproveRejectReviewModel> adminApproveRejectReview({
    required AdminApproveRejectReviewParams params,
  }) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);
    final String reviewID = params.reviewID;

    await api.patch(
      "${EndPoints.adminApproveRejectReview}$reviewID/",
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
      data: {"status": params.actionStatus},
    );

    return AdminApproveRejectReviewModel();
  }

  Future<List<ReviewsEntity>> adminGetAllReviews() async {
    final response = await api.get(EndPoints.getAllReviews);
    final List data = response.data;
    return data.map((json) => ReviewsModel.fromJson(json)).toList();
  }

  Future<ClinicModel> getClinicByID({
    required GetClinicByIDParams params,
  }) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);
    final String clinicID = params.clinicID;

    final response = await api.get(
      "${EndPoints.getClinics}/$clinicID",
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
    );

    return ClinicModel.fromJson(response);
  }
}
