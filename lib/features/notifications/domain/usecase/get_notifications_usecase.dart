import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/features/notifications/domain/entities/notification_entity.dart';
import 'package:glowguide/features/notifications/domain/repos/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<Either<Failure, List<NotificationEntity>>> call() {
    return repository.getCurrentUserNotifications();
  }
}
