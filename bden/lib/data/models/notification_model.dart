import '../../core/enums/notification_type.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final String? relatedId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        body: json['body'],
        type: NotificationType.values.byName(json['type']),
        relatedId: json['relatedId'],
        isRead: json['isRead'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'type': type.name,
        'relatedId': relatedId,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        userId: userId,
        title: title,
        body: body,
        type: type,
        relatedId: relatedId,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
      );
}
