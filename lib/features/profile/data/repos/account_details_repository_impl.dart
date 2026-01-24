import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/profile/data/sources/account_details_local_data_source.dart';
import 'package:glowguide/features/profile/data/sources/account_details_remote_data_source.dart';
import 'package:glowguide/features/profile/domain/entities/account_details_entity.dart';
import 'package:glowguide/features/profile/domain/entities/update_profile_entity.dart';
import 'package:glowguide/features/profile/domain/repos/account_details_repository.dart';
import 'package:dartz/dartz.dart';

class AccountDetailsRepositoryImpl extends AccountDetailsRepository {
  final NetworkInfo networkInfo;
  final AccountDetailsRemoteDataSource remoteDataSource;
  final AccountDetailsLocalDataSource localDataSource;

  AccountDetailsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, AccountDetailsEntity>> getAccountDetials() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAccountDetails = await remoteDataSource.getAccountDetails();

        localDataSource.cacheAccountDetails(remoteAccountDetails);

        return Right(remoteAccountDetails);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localAccountDetails =
            await localDataSource.getLastAccountDetails();
        return Right(localAccountDetails);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, UpdateProfileEntity>> updateProfile(
      {required UpdateProfileParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUpdate = await remoteDataSource.updateProfile(params);

        return Right(remoteUpdate);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }
}
