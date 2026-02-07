import 'package:glowguide/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsStates {}

class NotificationsInitial extends NotificationsStates {}

class GetNotificationsLoading extends NotificationsStates {}

class GetNotificationsSuccessfully extends NotificationsStates {
  final List<NotificationEntity> notifications;

  GetNotificationsSuccessfully({required this.notifications});
}

class GetNotificationsFailed extends NotificationsStates {
  final String errMessage;

  GetNotificationsFailed({required this.errMessage});
}

class PostNewNotificationLoading extends NotificationsStates {}

class PostNewNotificationSuccess extends NotificationsStates {}

class PostNewNotificationFailed extends NotificationsStates {
  final String errMessage;

  PostNewNotificationFailed({required this.errMessage});
}
