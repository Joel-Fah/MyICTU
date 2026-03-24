import '../models/pledge_model.dart';
import '../../core/enums/pledge_status.dart';

abstract class PledgeRepository {
  Future<void> createPledge(PledgeModel pledge);
  Stream<List<PledgeModel>> getDonorPledges(String donorId);
  Stream<List<PledgeModel>> getCampaignPledges(String campaignId);
  Future<void> updatePledgeStatus(String id, PledgeStatus status);
  Future<void> cancelPledge(String id);
  Future<PledgeModel?> getDonorPledgeForCampaign(
      String donorId, String campaignId);
}
