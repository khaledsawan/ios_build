import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/reviews/data/repos/reviews_repository_impl.dart';
import 'package:glowguide/features/reviews/data/source/reviews_local_data_source.dart';
import 'package:glowguide/features/reviews/data/source/reviews_remote_data_source.dart';
import 'package:glowguide/features/reviews/domain/usecase/get_reviews_by_clinic_i_d_usecase.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_clinic_i_d_states.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsClinicIDCubit extends Cubit<ReviewsClinicIDStates> {
  ReviewsClinicIDCubit() : super(ReviewsClinicIDInitial());

  Future<void> getAllReviewsByClinicID(
    GetReviewsByClinicIDParams params,
  ) async {
    emit(GetAllReviewsByClinicIDLoading());

    final failureOrGetReviews = await GetReviewsByClinicIDUsecase(
      repository: ReviewsRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: ReviewsRemoteDataSource(api: DioConsumer(dio: Dio())),
        localDataSource: ReviewsLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call(params: params);

    failureOrGetReviews.fold(
      (failure) =>
          emit(GetAllReviewsByClinicIDFailed(errMessage: failure.errMessage)),
      (reviews) => emit(GetAllReviewsByClinicIDSuccessfully(reviews: reviews)),
    );
  }
}
