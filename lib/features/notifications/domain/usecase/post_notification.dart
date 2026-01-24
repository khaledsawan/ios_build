import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/notifications/domain/entities/post_notificaiton_entity.dart';
import 'package:glowguide/features/notifications/domain/repos/notification_repository.dart';
import 'package:dartz/dartz.dart';

class PostNotification {
  final NotificationRepository repository;

  PostNotification({required this.repository});

  Future<Either<Failure, PostNotificaitonEntity>> call({
    required NotificationParams params,
  }) {
    return repository.postNotification(params: params);
  }
}
