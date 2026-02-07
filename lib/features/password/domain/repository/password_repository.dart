import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/password/domain/entities/confirm_reset_password_entity.dart';
import 'package:glowguide/features/password/domain/entities/new_password_entity.dart';
import 'package:glowguide/features/password/domain/entities/reset_password_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PasswordRepository {
  Future<Either<Failure, ResetPasswordEntity>> resetPassword({
    required ResetPasswordParams params,
  });

  Future<Either<Failure, ConfirmResetPasswordEntity>> confirmResetPassword(
      {required ConfirmResetPasswordParams params});

  Future<Either<Failure, NewPasswordEntity>> setNewPassword(
      {required NewPasswordParams params});

  Future<Either<Failure, void>> resetPasswordByPassword(
      {required ResetPasswordByPasswordParams params});
}
