import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/offers/data/source/offers_local_data_source.dart';
import 'package:glowguide/features/offers/data/source/offers_remote_data_source.dart';
import 'package:glowguide/features/offers/domain/entities/admin_approve_reject_offer_entity.dart';
import 'package:glowguide/features/offers/domain/entities/create_offer_entity.dart';
import 'package:glowguide/features/offers/domain/entities/get_all_offers_entities.dart';
import 'package:glowguide/features/offers/domain/repository/offer_repository.dart';
import 'package:dartz/dartz.dart';

class OffersRepositoryImpl extends OfferRepository {
  final NetworkInfo networkInfo;
  final OffersRemoteDataSource remoteDataSource;
  final OffersLocalDataSource localDataSource;

  OffersRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, CreateOfferEntity>> createNewOffer({
    required CreateOffersParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOffer = await remoteDataSource.createNewOffer(params);

        return Right(remoteOffer);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, List<GetAllOffersEntities>>> getAllOffers() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOffers = await remoteDataSource.getAllOffers();

        localDataSource.cacheOffers(remoteOffers);

        return Right(remoteOffers);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localOffers = await localDataSource.getLastOffers();

        return Right(localOffers);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, AdminApproveRejectOfferEntity>>
  adminApproveRejectOffers({
    required AdminApproveRejectOffersParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final approvAndReject = await remoteDataSource.adminApproveRejectOffer(
          params,
        );

        return Right(approvAndReject);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }
}
