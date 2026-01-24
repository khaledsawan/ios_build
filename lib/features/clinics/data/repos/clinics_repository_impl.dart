import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/data/source/clinics_local_data_source.dart';
import 'package:glowguide/features/clinics/data/source/clinics_remote_data_source.dart';
import 'package:glowguide/features/clinics/domain/entities/admin_approve_reject_clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/entities/create_new_clinic_entity.dart';
import 'package:glowguide/features/clinics/domain/repos/clinic_repository.dart';
import 'package:dartz/dartz.dart';

class ClinicsRepositoryImpl extends ClinicRepository {
  final NetworkInfo networkInfo;
  final ClinicsRemoteDataSource remoteDataSource;
  final ClinicsLocalDataSource localDataSource;

  ClinicsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ClinicEntity>>> getAllClinics() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteClinics = await remoteDataSource.getClinics();

        localDataSource.cacheClinics(remoteClinics);

        return Right(remoteClinics);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localClinis = await localDataSource.getLastClinics();

        return Right(localClinis);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, CreateNewClinicEntity>> createNewClinic({
    required CreateNewClinicParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final reponse = await remoteDataSource.createNewClinic(params);
        return Right(reponse);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, AdminApproveRejectClinicEntity>>
  admingApproveRejectClinic({
    required AdminApproveRejectClinicParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.adminApproveRejectClinic(
          params: params,
        );

        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }
}
