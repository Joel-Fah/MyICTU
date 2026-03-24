import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _notifService;
  final AuthController _authController = Get.find<AuthController>();

  NotificationController(this._notifService);

  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = _authController.currentUser.value?.uid;
    if (userId != null) {
      _notifService.getUserNotifications(userId).listen((data) {
        notifications.value = data;
        isLoading.value = false;
      });
      _notifService.getUnreadCount(userId).listen((count) {
        unreadCount.value = count;
      });
    }
  }

  Future<void> markAsRead(String id) => _notifService.markAsRead(id);

  Future<void> markAllAsRead() {
    final userId = _authController.currentUser.value?.uid;
    if (userId != null) return _notifService.markAllAsRead(userId);
    return Future.value();
  }
}
