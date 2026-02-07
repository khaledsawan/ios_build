import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/repos/clinic_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllClinicsUsecase {
  final ClinicRepository repository;

  GetAllClinicsUsecase({required this.repository});

  Future<Either<Failure, List<ClinicEntity>>> call() {
    return repository.getAllClinics();
  }
}
