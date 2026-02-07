import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/domain/entities/admin_approve_reject_clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/repos/clinic_repository.dart';
import 'package:dartz/dartz.dart';

class AdminApproveRejectClinicUsecase {
  final ClinicRepository repository;

  AdminApproveRejectClinicUsecase({required this.repository});

  Future<Either<Failure, AdminApproveRejectClinicEntity>> call({
    required AdminApproveRejectClinicParams params,
  }) {
    return repository.admingApproveRejectClinic(params: params);
  }
}
