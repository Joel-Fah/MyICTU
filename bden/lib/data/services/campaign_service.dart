import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/campaign_model.dart';
import '../repositories/campaign_repository.dart';
import '../../core/errors/firestore_exception.dart';

class CampaignService extends GetxService implements CampaignRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  CollectionReference get _col => _firestore.collection('campaigns');

  @override
  Stream<List<CampaignModel>> getCampaigns() {
    return _col
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map(
                (d) => CampaignModel.fromJson(d.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<CampaignModel> getCampaignById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) throw const FirestoreException('Campaign not found');
    return CampaignModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> createCampaign(CampaignModel campaign) async {
    final id = _uuid.v4();
    final c = campaign.copyWith();
    await _col.doc(id).set({...c.toJson(), 'id': id});
  }

  @override
  Future<void> updateCampaign(CampaignModel campaign) async {
    await _col.doc(campaign.id).update(campaign.toJson());
  }

  @override
  Future<void> deleteCampaign(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Future<String> uploadCoverImage(File file) async {
    final ref = _storage.ref('campaigns/${_uuid.v4()}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  @override
  Stream<List<CampaignModel>> getOrganizerCampaigns(String organizerId) {
    return _col
        .where('organizerId', isEqualTo: organizerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map(
                (d) => CampaignModel.fromJson(d.data() as Map<String, dynamic>))
            .toList());
  }
}
