import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/locations/data/source/locations_local_data_source.dart';
import 'package:glowguide/features/locations/data/source/locations_remote_data_source.dart';
import 'package:glowguide/features/locations/domain/entities/location_entity.dart';
import 'package:glowguide/features/locations/domain/repositories/locations_repository.dart';
import 'package:dartz/dartz.dart';

class LocationsRepositoryImpl extends LocationsRepository {
  final NetworkInfo networkInfo;
  final LocationsRemoteDataSource remoteDataSource;
  final LocationsLocalDataSource localDataSource;

  LocationsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<LocationEntity>>> getAllLocations() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLocations = await remoteDataSource.getAllLocations();

        localDataSource.cacheLocations(remoteLocations);

        return Right(remoteLocations);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localLocations = await localDataSource.getLastLocations();

        return Right(localLocations);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, void>> addNewLocation(
      {required AddLocationParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addNewLocation(params);

        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLocation(
      {required DeleteLocationParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteLocation(params);

        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }
}
