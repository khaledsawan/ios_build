import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/auth/domain/entities/login_entity.dart';
import 'package:glowguide/features/auth/domain/entities/sign_up_clinic_owner_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthReposirory {
  Future<Either<Failure, LoginEntity>> loginUser({required LoginParams params});

  Future<Either<Failure, SignUpClinicOwnerEntity>> signUpClinicOwner({
    required SignupUserParams params,
  });
}
