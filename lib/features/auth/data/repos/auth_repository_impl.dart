import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/auth/data/source/auth_remote_data_source.dart';
import 'package:glowguide/features/auth/domain/entities/login_entity.dart';
import 'package:glowguide/features/auth/domain/entities/sign_up_clinic_owner_entity.dart';
import 'package:glowguide/features/auth/domain/repos/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl extends AuthReposirory {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LoginEntity>> loginUser({
    required LoginParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final loggedInUserDetails = await remoteDataSource.loginUser(params);
        return Right(loggedInUserDetails);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }

  @override
  Future<Either<Failure, SignUpClinicOwnerEntity>> signUpClinicOwner({
    required SignupUserParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final signedUpClinicOwner = await remoteDataSource.signupUser(params);
        return Right(signedUpClinicOwner);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection!"));
    }
  }
}
