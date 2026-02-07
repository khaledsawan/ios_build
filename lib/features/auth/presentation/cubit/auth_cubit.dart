import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/auth/data/repos/auth_repository_impl.dart';
import 'package:glowguide/features/auth/data/source/auth_remote_data_source.dart';
import 'package:glowguide/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:glowguide/features/auth/domain/usecases/sign_up_clinic_owner_usecase.dart';
import 'package:glowguide/features/auth/presentation/cubit/auth_states.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginUserWithEmailAndPassword(LoginParams params) async {
    emit(LoginUserLoading());

    final failureOrLoggedInUser = await LoginUserUsecase(
      repository: AuthRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: AuthRemoteDataSource(api: DioConsumer(dio: Dio())),
      ),
    ).call(params: params);

    failureOrLoggedInUser.fold(
      (failure) => emit(LoginUserFailed(errMessage: failure.errMessage)),
      (loggedInUser) async {
        await getIt<CacheHelper>().save(
          key: ApiKey.access,
          value: loggedInUser.access,
        );

        await getIt<CacheHelper>().save(
          key: ApiKey.refresh,
          value: loggedInUser.refresh,
        );

        await getIt<CacheHelper>().save(
          key: ApiKey.type,
          value: loggedInUser.user.type,
        );

        await getIt<CacheHelper>().save(
          key: ApiKey.userID,
          value: loggedInUser.user.id,
        );

        await getIt<CacheHelper>().save(
          key: ApiKey.userFullName,
          value: loggedInUser.user.fullName,
        );

        if (loggedInUser.user.profilePic != null) {
          await getIt<CacheHelper>().save(
            key: ApiKey.userProfileImage,
            value: loggedInUser.user.profilePic!,
          );
        }

        emit(LoginUserSuccessfully(user: loggedInUser));
      },
    );
  }

  Future<void> signupUser(SignupUserParams params) async {
    emit(SignupUserLoading());

    final failureOrSignupClinicOwner = await SignUpClinicOwnerUsecase(
      repository: AuthRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: AuthRemoteDataSource(api: DioConsumer(dio: Dio())),
      ),
    ).call(params: params);

    failureOrSignupClinicOwner.fold(
      (failure) => emit(SignupUserFailed(errMessage: failure.errMessage)),
      (signedUpClinicOwner) async {
        emit(SignupUserSuccess());
      },
    );
  }

  void logout() async {
    await getIt<CacheHelper>().remove(ApiKey.access);
    await getIt<CacheHelper>().remove(ApiKey.refresh);
    await getIt<CacheHelper>().remove(ApiKey.type);
    await getIt<CacheHelper>().remove(ApiKey.userID);
    await getIt<CacheHelper>().remove(ApiKey.userFullName);
    await getIt<CacheHelper>().remove(ApiKey.userProfileImage);

    emit(AuthInitial());
  }
}
