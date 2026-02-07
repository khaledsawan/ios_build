import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/delete_account/data/repos/delete_account_repository_impl.dart';
import 'package:glowguide/features/delete_account/data/source/delete_account_remote_data_source.dart';
import 'package:glowguide/features/delete_account/domain/usecases/delete_account_usecase.dart';
import 'package:glowguide/features/delete_account/presentation/cubit/delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  Future<void> deleteAccount(DeleteAccountParams params) async {
    emit(DeleteAccountLoading());

    final result = await DeleteAccountUsecase(
      repository: DeleteAccountRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: DeleteAccountRemoteDataSource(
          api: DioConsumer(dio: Dio()),
        ),
      ),
    ).call(params: params);

    result.fold(
      (failure) => emit(DeleteAccountFailed(errMessage: failure.errMessage)),
      (_) => emit(DeleteAccountSuccess()),
    );
  }
}
