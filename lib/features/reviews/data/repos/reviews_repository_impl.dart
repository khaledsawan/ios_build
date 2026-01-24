import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/reviews/data/models/reviews_model.dart';
import 'package:glowguide/features/reviews/data/source/reviews_local_data_source.dart';
import 'package:glowguide/features/reviews/data/source/reviews_remote_data_source.dart';
import 'package:glowguide/features/reviews/domain/entities/admin_approve_reject_review_entity.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/reviews/domain/entities/write_review_entity.dart';
import 'package:glowguide/features/reviews/domain/repos/reviews_repository.dart';
import 'package:dartz/dartz.dart';

class ReviewsRepositoryImpl extends ReviewsRepository {
  final NetworkInfo networkInfo;
  final ReviewsRemoteDataSource remoteDataSource;
  final ReviewsLocalDataSource localDataSource;

  ReviewsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, WriteReviewEntity>> writeReiew({
    required WriteReviewParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final writeReview = await remoteDataSource.writeReview(params);
        return Right(writeReview);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<ReviewsEntity>>> getAllReviews() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReviews = await remoteDataSource.getAllReviews();

        localDataSource.cacheReviews(remoteReviews);

        return Right(remoteReviews);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localReviews = await localDataSource.getLastReviews();

        return Right(localReviews);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, AdminApproveRejectReviewEntity>>
  adimnApproveRejecrReview({
    required AdminApproveRejectReviewParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.adminApproveRejectReview(
          params: params,
        );
        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<ReviewsEntity>>> adminGetReviews() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReviews = await remoteDataSource.getAllReviews();

        final entityList = remoteReviews
            .map<ReviewsEntity>((review) => review as ReviewsEntity)
            .toList();

        return Right(entityList);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, ClinicEntity>> getClinicByID({
    required GetClinicByIDParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getClinicByID(params: params);

        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, List<ReviewsModel>>> getReviewsByClinicID({
    required GetReviewsByClinicIDParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReviews = await remoteDataSource.getReviewsByClinicID(
          params: params,
        );

        localDataSource.cacheReviews(remoteReviews as List<ReviewsModel>?);

        return Right(remoteReviews);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localReviews = await localDataSource.getLastReviews();
        return Right(localReviews);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }
}
