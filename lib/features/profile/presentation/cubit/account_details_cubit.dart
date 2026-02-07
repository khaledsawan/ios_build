import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/profile/data/repos/account_details_repository_impl.dart';
import 'package:glowguide/features/profile/data/sources/account_details_local_data_source.dart';
import 'package:glowguide/features/profile/data/sources/account_details_remote_data_source.dart';
import 'package:glowguide/features/profile/domain/usecase/get_account_details_usecase.dart';
import 'package:glowguide/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_states.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDetailsCubit extends Cubit<AccountDetailsStates> {
  AccountDetailsCubit() : super(AccountDetailsInitial());

  Future<void> fetchAccountDetails() async {
    emit(GetAccountDetailsLoading());

    final failureOrAccountDetails = await GetAccountDetailsUsecase(
      repository: AccountDetailsRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: AccountDetailsRemoteDataSource(
          api: DioConsumer(dio: Dio()),
        ),
        localDataSource:
            AccountDetailsLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call();

    failureOrAccountDetails.fold(
      (failure) =>
          emit(GetAccountDetailsFailure(errMessage: failure.errMessage)),
      (account) => emit(GetAccountDetailsSuccessfully(accountDetails: account)),
    );
  }

  Future<void> updateProfile({UpdateProfileParams? params}) async {
    emit(UpdateProfileLoading());

    final failureOrUpdated = await UpdateProfileUsecase(
            repository: AccountDetailsRepositoryImpl(
                networkInfo: getIt<NetworkInfo>(),
                remoteDataSource: AccountDetailsRemoteDataSource(
                    api: DioConsumer(dio: Dio())),
                localDataSource:
                    AccountDetailsLocalDataSource(cache: getIt<CacheHelper>())))
        .call(params: params!);

    failureOrUpdated.fold(
        (failure) => emit(UpdateProfileFailed(errMessage: failure.errMessage)),
        (updated) => emit(UpdateProfileSuccessfully()));
  }
}
