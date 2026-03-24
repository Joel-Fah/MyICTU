import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/pledge_model.dart';
import '../repositories/pledge_repository.dart';
import '../../core/enums/pledge_status.dart';

class PledgeService extends GetxService implements PledgeRepository {
  final _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  CollectionReference get _col => _firestore.collection('pledges');

  @override
  Future<void> createPledge(PledgeModel pledge) async {
    final id = _uuid.v4();
    await _col.doc(id).set({...pledge.toJson(), 'id': id});
    // Increment unitsPledged on the campaign
    await _firestore
        .collection('campaigns')
        .doc(pledge.campaignId)
        .update({'unitsPledged': FieldValue.increment(1)});
  }

  @override
  Stream<List<PledgeModel>> getDonorPledges(String donorId) {
    return _col
        .where('donorId', isEqualTo: donorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map((d) => PledgeModel.fromJson(d.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Stream<List<PledgeModel>> getCampaignPledges(String campaignId) {
    return _col
        .where('campaignId', isEqualTo: campaignId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map((d) => PledgeModel.fromJson(d.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<void> updatePledgeStatus(String id, PledgeStatus status) async {
    final doc = await _col.doc(id).get();
    final pledge = PledgeModel.fromJson(doc.data() as Map<String, dynamic>);

    await _col.doc(id).update({
      'status': status.name,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // If confirmed, increment unitsConfirmed
    if (status == PledgeStatus.confirmed) {
      await _firestore
          .collection('campaigns')
          .doc(pledge.campaignId)
          .update({'unitsConfirmed': FieldValue.increment(1)});
    }
  }

  @override
  Future<void> cancelPledge(String id) async {
    final doc = await _col.doc(id).get();
    final pledge = PledgeModel.fromJson(doc.data() as Map<String, dynamic>);

    await _col.doc(id).update({
      'status': PledgeStatus.cancelled.name,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    await _firestore
        .collection('campaigns')
        .doc(pledge.campaignId)
        .update({'unitsPledged': FieldValue.increment(-1)});
  }

  @override
  Future<PledgeModel?> getDonorPledgeForCampaign(
      String donorId, String campaignId) async {
    final snap = await _col
        .where('donorId', isEqualTo: donorId)
        .where('campaignId', isEqualTo: campaignId)
        .where('status', isEqualTo: 'pledged')
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return PledgeModel.fromJson(snap.docs.first.data() as Map<String, dynamic>);
  }
}
