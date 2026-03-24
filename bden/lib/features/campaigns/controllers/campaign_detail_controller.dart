import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/campaign_model.dart';
import '../../../data/models/pledge_model.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../data/repositories/pledge_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/models/notification_model.dart';
import '../../../core/enums/notification_type.dart';
import 'package:uuid/uuid.dart';

class CampaignDetailController extends GetxController {
  final CampaignRepository _campaignService;
  final PledgeRepository _pledgeService;
  final NotificationRepository _notifService;
  final AuthController _authController = Get.find<AuthController>();

  CampaignDetailController(
    this._campaignService,
    this._pledgeService,
    this._notifService,
  );

  String get currentUserId => _authController.currentUser.value?.uid ?? '';
  String get currentUserName =>
      _authController.currentUser.value?.displayName ?? '';

  final campaign = Rxn<CampaignModel>();
  final pledges = <PledgeModel>[].obs;
  final currentPledge = Rxn<PledgeModel>();
  final isLoading = true.obs;
  final isActing = false.obs;

  bool get hasPledged => currentPledge.value != null;

  void loadCampaign(String campaignId) {
    isLoading.value = true;
    _campaignService.getCampaigns().listen((list) {
      campaign.value = list.firstWhereOrNull((c) => c.id == campaignId);
      isLoading.value = false;
    });
    _pledgeService.getCampaignPledges(campaignId).listen((p) {
      pledges.value = p;
    });
    _checkPledge(campaignId);
  }

  Future<void> _checkPledge(String campaignId) async {
    currentPledge.value = await _pledgeService.getDonorPledgeForCampaign(
        currentUserId, campaignId);
  }

  Future<void> pledgeToDonate(PledgeModel pledge) async {
    isActing.value = true;
    try {
      await _pledgeService.createPledge(pledge);
      currentPledge.value = pledge;
      // Notify organizer
      await _notifService.createNotification(NotificationModel(
        id: const Uuid().v4(),
        userId: campaign.value!.organizerId,
        title: 'New pledge 💉',
        body:
            '$currentUserName just pledged to donate for "${campaign.value!.title}"',
        type: NotificationType.pledgeUpdate,
        relatedId: campaign.value!.id,
        createdAt: DateTime.now(),
      ));
    } finally {
      isActing.value = false;
    }
  }

  Future<void> cancelPledge() async {
    if (currentPledge.value == null) return;
    isActing.value = true;
    try {
      await _pledgeService.cancelPledge(currentPledge.value!.id);
      currentPledge.value = null;
    } finally {
      isActing.value = false;
    }
  }
}
