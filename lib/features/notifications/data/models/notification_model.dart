import 'package:glowguide/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  final String recipient;
  final String createdBy;

  NotificationModel({
    required super.notificationContent,
    required super.createdAt,
    required this.recipient,
    required this.createdBy,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationContent: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      recipient: json['recipient'] ?? '',
      createdBy: json['created_by'] ?? '',
    );
  }

  static List<NotificationModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'content': notificationContent,
      'created_at': createdAt.toIso8601String(),
      'recipient': recipient,
      'created_by': createdBy,
    };
  }
}
