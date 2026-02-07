import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/notifications/data/repos/notifications_repository_impl.dart';
import 'package:glowguide/features/notifications/data/source/notifications_local_data_source.dart';
import 'package:glowguide/features/notifications/data/source/notifications_remote_data_source.dart';
import 'package:glowguide/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:glowguide/features/notifications/domain/usecase/post_notification.dart';
import 'package:glowguide/features/notifications/presentation/cubit/notifications_states.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> getCurrentUserNotifications() async {
    emit(GetNotificationsLoading());

    final failureOrGetNotifications = await GetNotificationsUsecase(
      repository: NotificationsRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: NotificationsRemoteDataSource(
          api: DioConsumer(dio: Dio()),
        ),
        localDataSource:
            NotificationsLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call();

    failureOrGetNotifications.fold(
      (failure) {
        emit(GetNotificationsFailed(errMessage: failure.errMessage));
      },
      (notificationsList) {
        emit(GetNotificationsSuccessfully(notifications: notificationsList));
      },
    );
  }

  Future<void> postANewNotification(String content, String recipientId) async {
    final failureOrPostedNotification = await PostNotification(
      repository: NotificationsRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        remoteDataSource: NotificationsRemoteDataSource(
          api: DioConsumer(dio: Dio()),
        ),
        localDataSource:
            NotificationsLocalDataSource(cache: getIt<CacheHelper>()),
      ),
    ).call(
      params: NotificationParams(recipient: recipientId, content: content),
    );

    failureOrPostedNotification.fold(
      (failure) => emit(
        PostNewNotificationFailed(
          errMessage: "An Error ocurred please try again!",
        ),
      ),
      (postedNotification) => emit(PostNewNotificationSuccess()),
    );
  }
}
