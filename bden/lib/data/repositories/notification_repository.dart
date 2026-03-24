import '../models/notification_model.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> getUserNotifications(String userId);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead(String userId);
  Future<void> createNotification(NotificationModel notification);
  Stream<int> getUnreadCount(String userId);
}
