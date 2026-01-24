import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/locations/domain/entities/location_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LocationsRepository {
  Future<Either<Failure, List<LocationEntity>>> getAllLocations();

  Future<Either<Failure, void>> addNewLocation(
      {required AddLocationParams params});

  Future<Either<Failure, void>> deleteLocation(
      {required DeleteLocationParams params});
}
