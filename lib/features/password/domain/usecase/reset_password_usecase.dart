import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/password/domain/entities/reset_password_entity.dart';
import 'package:glowguide/features/password/domain/repository/password_repository.dart';
import 'package:dartz/dartz.dart';

class ResetPasswordUsecase {
  final PasswordRepository repository;

  ResetPasswordUsecase({required this.repository});

  Future<Either<Failure, ResetPasswordEntity>> call({
    required ResetPasswordParams params,
  }) {
    return repository.resetPassword(params: params);
  }
}
