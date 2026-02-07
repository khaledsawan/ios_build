import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/offers/data/repository/offers_repository_impl.dart';
import 'package:glowguide/features/offers/data/source/offers_local_data_source.dart';
import 'package:glowguide/features/offers/data/source/offers_remote_data_source.dart';
import 'package:glowguide/features/offers/domain/usecases/admin_approve_reject_offers_usecase.dart';
import 'package:glowguide/features/offers/domain/usecases/create_new_offer_usecase.dart';
import 'package:glowguide/features/offers/domain/usecases/get_all_offers_usecase.dart';
import 'package:glowguide/features/offers/presentation/cubit/offer_states.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersCubit extends Cubit<OfferStates> {
  OffersCubit() : super(OffersInitial());

  Future<void> createNewOffer(CreateOffersParams params) async {
    emit(CreateNewOfferLoading());

    final failureOrCreatedOffer = await CreateNewOfferUsecase(
      repository: OffersRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: OffersRemoteDataSource(api: DioConsumer(dio: Dio())),
        localDataSource: OffersLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call(params: params);

    failureOrCreatedOffer.fold(
      (failure) => emit(CreateNewOfferFailed(errMessage: failure.errMessage)),
      (offer) => emit(CreateNewOfferSuccessfully()),
    );
  }

  Future<void> getAllOfferss() async {
    emit(GetAllOffersLoading());

    final failureOrGetOffers = await GetAllOffersUsecase(
      repository: OffersRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: OffersRemoteDataSource(api: DioConsumer(dio: Dio())),
        localDataSource: OffersLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call();

    failureOrGetOffers.fold(
      (failure) {
        emit(GetAllOffersFailed(errMessage: failure.errMessage));
      },
      (offers) {
        emit(GetAllOffersSuccessfully(offer: offers));
      },
    );
  }

  Future<void> adminApproveRejectOffers(
    AdminApproveRejectOffersParams params,
  ) async {
    emit(AdminApproveRejectOfferLoading());

    final failureOrApprovedRejected = await AdminApproveRejectOffersUsecase(
      repository: OffersRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: OffersRemoteDataSource(api: DioConsumer(dio: Dio())),
        localDataSource: OffersLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call(params: params);

    failureOrApprovedRejected.fold(
      (failure) =>
          emit(AdminApproveRejectOfferFailed(errMessage: failure.errMessage)),
      (success) => emit(AdminApproveRejectOfferSuccessfully()),
    );

    await getAllOfferss();
  }
}
