import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/domain/entities/admin_approve_reject_clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/entities/create_new_clinic_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ClinicRepository {
  Future<Either<Failure, List<ClinicEntity>>> getAllClinics();

  Future<Either<Failure, CreateNewClinicEntity>> createNewClinic({
    required CreateNewClinicParams params,
  });

  Future<Either<Failure, AdminApproveRejectClinicEntity>>
      admingApproveRejectClinic(
          {required AdminApproveRejectClinicParams params});
}
