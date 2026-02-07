import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/domain/entities/create_new_clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/repos/clinic_repository.dart';
import 'package:dartz/dartz.dart';

class CreateNewClinicUsecase {
  final ClinicRepository repository;

  CreateNewClinicUsecase({required this.repository});

  Future<Either<Failure, CreateNewClinicEntity>> call({
    required CreateNewClinicParams params,
  }) {
    return repository.createNewClinic(params: params);
  }
}
