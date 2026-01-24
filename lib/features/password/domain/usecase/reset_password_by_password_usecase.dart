import 'package:dartz/dartz.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/password/domain/repository/password_repository.dart';

class ResetPasswordByPasswordUsecase {
  final PasswordRepository repository;

  ResetPasswordByPasswordUsecase({required this.repository});

  Future<Either<Failure, void>> call(
      {required ResetPasswordByPasswordParams params}) {
    return repository.resetPasswordByPassword(params: params);
  }
}
