import 'dart:convert';

import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/notifications/data/models/notification_model.dart';

class NotificationsLocalDataSource {
  CacheHelper cache = getIt<CacheHelper>();
  final String key = "CachedNotifications";

  NotificationsLocalDataSource({required this.cache});

  void cacheNotifications(List<NotificationModel> notifications) {
    final encoded = jsonEncode(notifications.map((n) => n.toJson()).toList());

    cache.save(key: key, value: encoded);
  }

  Future<List<NotificationModel>> getLastNotifications() {
    final jsonString = cache.get(key);

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return Future.value(NotificationModel.fromJsonList(decoded));
    } else {
      throw CacheExeption(errorMessage: "No Cached Notifications!");
    }
  }
}
