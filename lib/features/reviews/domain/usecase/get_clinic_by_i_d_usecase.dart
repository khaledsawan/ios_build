import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/reviews/domain/repos/reviews_repository.dart';
import 'package:dartz/dartz.dart';

class GetClinicByIDUsecase {
  final ReviewsRepository repository;

  GetClinicByIDUsecase({required this.repository});

  Future<Either<Failure, ClinicEntity>> call({
    required GetClinicByIDParams params,
  }) {
    return repository.getClinicByID(params: params);
  }
}
