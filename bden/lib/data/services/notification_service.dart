import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationService extends GetxService
    implements NotificationRepository {
  final _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  CollectionReference get _col => _firestore.collection('notifications');

  @override
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _col
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((s) => s.docs
            .map((d) =>
                NotificationModel.fromJson(d.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<void> markAsRead(String id) async {
    await _col.doc(id).update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final snap = await _col
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  Future<void> createNotification(NotificationModel notification) async {
    final id = _uuid.v4();
    await _col.doc(id).set({...notification.toJson(), 'id': id});
  }

  @override
  Stream<int> getUnreadCount(String userId) {
    return _col
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((s) => s.docs.length);
  }
}
