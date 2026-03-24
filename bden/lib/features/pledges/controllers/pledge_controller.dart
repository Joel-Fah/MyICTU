import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/pledge_model.dart';
import '../../../data/repositories/pledge_repository.dart';

class PledgeController extends GetxController {
  final PledgeRepository _pledgeService;
  final AuthController _authController = Get.find<AuthController>();

  PledgeController(this._pledgeService);

  final pledges = <PledgeModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final user = _authController.currentUser.value;
    if (user != null) {
      _pledgeService.getDonorPledges(user.uid).listen((data) {
        pledges.value = data;
        isLoading.value = false;
      });
    }
  }

  Future<void> cancelPledge(String pledgeId) async {
    await _pledgeService.cancelPledge(pledgeId);
  }
}
