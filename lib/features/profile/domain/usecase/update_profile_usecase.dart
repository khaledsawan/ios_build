import 'package:dartz/dartz.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/profile/domain/entities/update_profile_entity.dart';
import 'package:glowguide/features/profile/domain/repos/account_details_repository.dart';

class UpdateProfileUsecase {
  final AccountDetailsRepository repository;

  UpdateProfileUsecase({required this.repository});

  Future<Either<Failure, UpdateProfileEntity>> call(
      {required UpdateProfileParams params}) {
    return repository.updateProfile(params: params);
  }
}
