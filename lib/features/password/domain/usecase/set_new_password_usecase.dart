import 'package:dartz/dartz.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/password/domain/entities/new_password_entity.dart';
import 'package:glowguide/features/password/domain/repository/password_repository.dart';

class SetNewPasswordUsecase {
  final PasswordRepository repository;

  SetNewPasswordUsecase({required this.repository});

  Future<Either<Failure, NewPasswordEntity>> call(
      {required NewPasswordParams params}) {
    return repository.setNewPassword(params: params);
  }
}
