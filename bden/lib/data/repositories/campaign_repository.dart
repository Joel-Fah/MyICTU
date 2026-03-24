import 'dart:io';
import '../models/campaign_model.dart';

abstract class CampaignRepository {
  Stream<List<CampaignModel>> getCampaigns();
  Future<CampaignModel> getCampaignById(String id);
  Future<void> createCampaign(CampaignModel campaign);
  Future<void> updateCampaign(CampaignModel campaign);
  Future<void> deleteCampaign(String id);
  Future<String> uploadCoverImage(File file);
  Stream<List<CampaignModel>> getOrganizerCampaigns(String organizerId);
}
