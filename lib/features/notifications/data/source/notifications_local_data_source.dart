import 'dart:convert';

import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/features/notifications/data/models/notification_model.dart';

class NotificationsLocalDataSource {
  final CacheHelper cache;
  final String key = "CachedNotifications";

  NotificationsLocalDataSource({required this.cache});

  void cacheNotifications(List<NotificationModel> notifications) {
    final encoded = jsonEncode(notifications.map((n) => n.toJson()).toList());

    cache.saveData(key: key, value: encoded);
  }

  Future<List<NotificationModel>> getLastNotifications() {
    final jsonString = cache.getDataString(key: key);

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return Future.value(NotificationModel.fromJsonList(decoded));
    } else {
      throw CacheExeption(errorMessage: "No Cached Notifications!");
    }
  }
}
