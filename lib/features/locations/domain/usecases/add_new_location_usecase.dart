import 'package:dartz/dartz.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/locations/domain/repositories/locations_repository.dart';

class AddNewLocationUsecase {
  final LocationsRepository repository;

  AddNewLocationUsecase({required this.repository});

  Future<Either<Failure, void>> call({required AddLocationParams params}) {
    return repository.addNewLocation(params: params);
  }
}
