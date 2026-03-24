import 'package:get/get.dart';
import '../../../data/models/campaign_model.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../core/enums/blood_type.dart';
import '../../../core/enums/campaign_urgency.dart';

class CampaignFeedController extends GetxController {
  final CampaignRepository _campaignService;
  CampaignFeedController(this._campaignService);

  final campaigns = <CampaignModel>[].obs;
  final isLoading = true.obs;
  final selectedBloodTypes = <BloodType>[].obs;
  final selectedUrgency = Rxn<CampaignUrgency>();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToCampaigns();
  }

  void _listenToCampaigns() {
    _campaignService.getCampaigns().listen((data) {
      campaigns.value = data;
      isLoading.value = false;
    });
  }

  List<CampaignModel> get filteredCampaigns {
    return campaigns.where((c) {
      final matchBlood = selectedBloodTypes.isEmpty ||
          c.bloodTypesNeeded.any((bt) => selectedBloodTypes.contains(bt));
      final matchUrgency =
          selectedUrgency.value == null || c.urgency == selectedUrgency.value;
      final matchSearch = searchQuery.isEmpty ||
          c.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          c.city.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchBlood && matchUrgency && matchSearch;
    }).toList();
  }

  void toggleBloodTypeFilter(BloodType bt) {
    if (selectedBloodTypes.contains(bt)) {
      selectedBloodTypes.remove(bt);
    } else {
      selectedBloodTypes.add(bt);
    }
  }

  void setUrgencyFilter(CampaignUrgency? urgency) {
    selectedUrgency.value = urgency;
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  void clearFilters() {
    selectedBloodTypes.clear();
    selectedUrgency.value = null;
    searchQuery.value = '';
  }
}
