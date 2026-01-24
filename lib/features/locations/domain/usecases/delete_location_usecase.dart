import 'package:dartz/dartz.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/locations/domain/repositories/locations_repository.dart';

class DeleteLocationUsecase {
  final LocationsRepository repository;

  DeleteLocationUsecase({required this.repository});

  Future<Either<Failure, void>> call({required DeleteLocationParams params}) {
    return repository.deleteLocation(params: params);
  }
}
