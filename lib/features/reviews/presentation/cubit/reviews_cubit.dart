import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/reviews/data/repos/reviews_repository_impl.dart';
import 'package:glowguide/features/reviews/data/source/reviews_local_data_source.dart';
import 'package:glowguide/features/reviews/data/source/reviews_remote_data_source.dart';
import 'package:glowguide/features/reviews/domain/usecase/admin_approve_reject_review_usecase.dart';
import 'package:glowguide/features/reviews/domain/usecase/get_all_reviews_usecase.dart';
import 'package:glowguide/features/reviews/domain/usecase/write_a_review_usecase.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_states.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsCubit extends Cubit<ReviewsStates> {
  ReviewsCubit() : super(ReviewsInitial());

  Future<void> getAllReviews() async {
    emit(GetAllReviewsLoading());

    final failureOrGetReviews = await GetAllReviewsUsecase(
      repository: ReviewsRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: ReviewsRemoteDataSource(api: DioConsumer(dio: Dio())),
        localDataSource: ReviewsLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call();

    failureOrGetReviews.fold(
      (failure) => emit(GetAllReviewsFailed(errMessage: failure.errMessage)),
      (reviews) => emit(GetAllReviewsSuccessfully(reviews: reviews)),
    );
  }

  Future<void> writeNewReview(WriteReviewParams params) async {
    emit(WriteReviewLoading());

    final failureOrWriteReview = await WriteAReviewUsecase(
      repository: ReviewsRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: ReviewsRemoteDataSource(api: DioConsumer(dio: Dio())),
        localDataSource: ReviewsLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call(params: params);

    failureOrWriteReview.fold(
      (failure) => emit(WriteReviewFailed(errMessage: failure.errMessage)),
      (review) => emit(WriteReviewSuccessfully()),
    );
  }

  Future<void> admingApproveRejectReview({
    required AdminApproveRejectReviewParams params,
  }) async {
    emit(AdmingApproveRejectReviewLoading());

    final response = await AdminApproveRejectReviewUsecase(
      repository: ReviewsRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: ReviewsRemoteDataSource(api: DioConsumer(dio: Dio())),
        localDataSource: ReviewsLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call(params: params);

    response.fold(
      (failure) =>
          emit(AdmingApproveRejectReviewFailed(errMessage: failure.errMessage)),
      (approved) {
        emit(AdmingApproveRejectReviewSuccess());

        getAllReviews();
      },
    );
  }
}
