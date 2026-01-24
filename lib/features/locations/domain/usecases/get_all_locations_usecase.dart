import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/features/locations/domain/entities/location_entity.dart';
import 'package:glowguide/features/locations/domain/repositories/locations_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllLocationsUsecase {
  final LocationsRepository repository;

  GetAllLocationsUsecase({required this.repository});

  Future<Either<Failure, List<LocationEntity>>> call() {
    return repository.getAllLocations();
  }
}
