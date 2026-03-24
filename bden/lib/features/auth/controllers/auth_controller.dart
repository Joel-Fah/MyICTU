import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/enums/user_role.dart';

class AuthController extends GetxController {
  final AuthRepository _authService;

  AuthController(this._authService);

  final currentUser = Rxn<UserModel>();
  final isOnboarded = false.obs;
  final isAuthReady = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final _box = GetStorage();
  static const _onboardedKey = 'onboarding_done';

  @override
  void onInit() {
    super.onInit();
    isOnboarded.value = _box.read<bool>(_onboardedKey) ?? false;
    _authService.authStateChanges().listen((user) {
      currentUser.value = user;
      _checkOnboardingStatus(user);
      isAuthReady.value = true;
    });
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authService.signInWithGoogle();
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.signInWithEmail(email, password);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    // Do not remove onboarding key unless necessary.
    // We want to remember the device state if possible, but actually we rely on user data now.
    // So removing it is fine as long as login restores it.
    _box.remove(_onboardedKey);
    isOnboarded.value = false;
  }

  Future<void> updateRole(UserRole role) async {
    if (currentUser.value == null) return;
    final updated = currentUser.value!.copyWith(role: role);
    await _authService.updateUserProfile(updated);
    currentUser.value = updated;
    _checkOnboardingStatus(updated);
  }

  Future<void> completeOnboarding() async {
    _box.write(_onboardedKey, true);
    isOnboarded.value = true;
    _checkOnboardingStatus(currentUser.value);
  }

  void _checkOnboardingStatus(UserModel? user) {
    if (user == null) {
      isOnboarded.value = false;
      return;
    }
    // Organizers are assumed done. Donors need blood type setup.
    if (user.isOrganizer) {
      isOnboarded.value = true;
      _box.write(_onboardedKey, true);
      return;
    }
    if (user.isDonor && user.bloodType != null) {
      isOnboarded.value = true;
      _box.write(_onboardedKey, true);
      return;
    }
    // Fallback: check storage
    isOnboarded.value = _box.read<bool>(_onboardedKey) ?? false;
  }
}
