import 'package:dio/dio.dart';
import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/password/data/source/password_remote_data_source.dart';
import 'package:glowguide/features/password/domain/entities/confirm_reset_password_entity.dart';
import 'package:glowguide/features/password/domain/entities/new_password_entity.dart';
import 'package:glowguide/features/password/domain/entities/reset_password_entity.dart';
import 'package:glowguide/features/password/domain/repository/password_repository.dart';
import 'package:dartz/dartz.dart';

class PasswordRepositoryImpl extends PasswordRepository {
  final NetworkInfo networkInfo;
  final PasswordRemoteDataSource remoteDataSource;

  PasswordRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResetPasswordEntity>> resetPassword({
    required ResetPasswordParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(params);

        return Right(ResetPasswordEntity(detail: "Success"));
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      } catch (e) {
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, ConfirmResetPasswordEntity>> confirmResetPassword(
      {required ConfirmResetPasswordParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.confirmResetPassword(params);

        return Right(ConfirmResetPasswordEntity(tempToken: response.tempToken));
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, NewPasswordEntity>> setNewPassword(
      {required NewPasswordParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.setNewPassword(params);
        return Right(NewPasswordEntity());
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, void>> resetPasswordByPassword(
      {required ResetPasswordByPasswordParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPasswordByPassword(params);

        return const Right(null);
      } on DioException catch (e) {
        return Left(Failure(errMessage: e.toString()));
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }
}
