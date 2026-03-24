import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/enums/blood_type.dart';

class OnboardingController extends GetxController {
  final AuthRepository _authRepo;
  final AuthController _authController = Get.find();

  OnboardingController(this._authRepo);

  final selectedBloodType = Rxn<BloodType>();
  final city = ''.obs;
  final region = ''.obs;
  final isLoading = false.obs;

  // Cameroon regions
  final regions = [
    'Adamaoua',
    'Centre',
    'Est',
    'Extrême-Nord',
    'Littoral',
    'Nord',
    'Nord-Ouest',
    'Ouest',
    'Sud',
    'Sud-Ouest'
  ];

  void selectBloodType(BloodType type) => selectedBloodType.value = type;
  void setCity(String val) => city.value = val;
  void setRegion(String val) => region.value = val;

  Future<void> completeSetup() async {
    if (selectedBloodType.value == null ||
        city.value.isEmpty ||
        region.value.isEmpty) {
      return;
    }

    isLoading.value = true;
    try {
      final currentUser = _authController.currentUser.value;
      if (currentUser != null) {
        final updated = currentUser.copyWith(
          bloodType: selectedBloodType.value,
          city: city.value,
          region: region.value,
        );
        await _authRepo.updateUserProfile(updated);
        _authController.currentUser.value = updated; // Update local state
      }
      await _authController.completeOnboarding();
    } finally {
      isLoading.value = false;
    }
  }
}
