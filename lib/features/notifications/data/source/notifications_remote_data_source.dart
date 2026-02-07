import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/notifications/data/models/notification_model.dart';
import 'package:glowguide/features/notifications/data/models/post_notification_model.dart';
import 'package:dio/dio.dart';

class NotificationsRemoteDataSource {
  final ApiConsumer api;

  NotificationsRemoteDataSource({required this.api});

  Future<List<NotificationModel>> getNotifications() async {
    final String access = await getIt<CacheHelper>().get(ApiKey.access);

    final response = await api.get(
      EndPoints.getNotifications,
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );

    return NotificationModel.fromJsonList(response);
  }

  Future<PostNotificationModel> postNotification(
    NotificationParams params,
  ) async {
    final String access = await getIt<CacheHelper>().get(ApiKey.access);

    final response = await api.post(
      EndPoints.createNotification,
      options: Options(
        headers: {
          'Authorization': 'Bearer $access',
          "Content-Type": "application/json",
        },
      ),
      data: {"recipient": params.recipient, "content": params.content},
    );

    return PostNotificationModel.fromJson(response);
  }
}
