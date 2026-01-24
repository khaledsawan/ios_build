import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/notifications/data/source/notifications_local_data_source.dart';
import 'package:glowguide/features/notifications/data/source/notifications_remote_data_source.dart';
import 'package:glowguide/features/notifications/domain/entities/notification_entity.dart';
import 'package:glowguide/features/notifications/domain/entities/post_notificaiton_entity.dart';
import 'package:glowguide/features/notifications/domain/repos/notification_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationsRepositoryImpl extends NotificationRepository {
  final NetworkInfo networkInfo;
  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsLocalDataSource localDataSource;

  NotificationsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<NotificationEntity>>>
  getCurrentUserNotifications() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNotifications = await remoteDataSource.getNotifications();

        localDataSource.cacheNotifications(remoteNotifications);

        return Right(remoteNotifications);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localNotifications = await localDataSource.getLastNotifications();

        return Right(localNotifications);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, PostNotificaitonEntity>> postNotification({
    required NotificationParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final postNotification = await remoteDataSource.postNotification(
          params,
        );

        return Right(postNotification);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connections!"));
    }
  }
}
