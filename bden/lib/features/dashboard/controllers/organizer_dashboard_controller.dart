import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/campaign_model.dart';
import '../../../data/models/pledge_model.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../data/repositories/pledge_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/models/notification_model.dart';
import '../../../core/enums/campaign_status.dart';
import '../../../core/enums/pledge_status.dart';
import '../../../core/enums/notification_type.dart';
import 'package:uuid/uuid.dart';

class OrganizerDashboardController extends GetxController {
  final CampaignRepository _campaignService;
  final PledgeRepository _pledgeService;
  final NotificationRepository _notifService;
  final AuthController _authController = Get.find<AuthController>();

  OrganizerDashboardController(
    this._campaignService,
    this._pledgeService,
    this._notifService,
  );

  String get organizerId => _authController.currentUser.value!.uid;

  final campaigns = <CampaignModel>[].obs;
  final pledgesMap = <String, List<PledgeModel>>{}.obs;
  final isLoading = true.obs;

  int get totalPledges =>
      pledgesMap.values.fold(0, (sum, list) => sum + list.length);
  int get totalConfirmed =>
      campaigns.fold(0, (sum, c) => sum + c.unitsConfirmed);

  @override
  void onInit() {
    super.onInit();
    _loadDashboard();
  }

  void _loadDashboard() {
    _campaignService.getOrganizerCampaigns(organizerId).listen((list) {
      campaigns.value = list;
      isLoading.value = false;
      for (final c in list) {
        _pledgeService.getCampaignPledges(c.id).listen((pledges) {
          pledgesMap[c.id] = pledges;
          pledgesMap.refresh();
        });
      }
    });
  }

  Future<void> confirmPledge(PledgeModel pledge) async {
    await _pledgeService.updatePledgeStatus(pledge.id, PledgeStatus.confirmed);
    await _notifService.createNotification(NotificationModel(
      id: const Uuid().v4(),
      userId: pledge.donorId,
      title: 'Pledge confirmed 🎉',
      body: 'Your donation pledge has been confirmed. Thank you!',
      type: NotificationType.pledgeUpdate,
      relatedId: pledge.campaignId,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> closeCampaign(String campaignId) async {
    final campaign = campaigns.firstWhere((c) => c.id == campaignId);
    await _campaignService.updateCampaign(
      campaign.copyWith(status: CampaignStatus.completed),
    );
  }

  List<PledgeModel> pledgesFor(String campaignId) =>
      pledgesMap[campaignId] ?? [];
}
