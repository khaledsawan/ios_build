import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/profile/domain/entities/account_details_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:glowguide/features/profile/domain/entities/update_profile_entity.dart';

abstract class AccountDetailsRepository {
  Future<Either<Failure, AccountDetailsEntity>> getAccountDetials();

  Future<Either<Failure, UpdateProfileEntity>> updateProfile(
      {required UpdateProfileParams params});
}
