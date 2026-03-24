import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/enums/blood_type.dart';
import '../../../../shared/widgets/bden_button.dart';
import '../../../../shared/widgets/bden_text_field.dart';
import '../controllers/onboarding_controller.dart';
import '../../../../data/repositories/auth_repository.dart';

class DonorSetupScreen extends StatelessWidget {
  const DonorSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller here since routes file might not do it.
    // Ideally use Get.put in binding or before navigation.
    // For simplicity I'll put it here if not found.
    final controller =
        Get.put(OnboardingController(Get.find<AuthRepository>()));

    return Scaffold(
      appBar: AppBar(title: const Text("Profile Setup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("A bit about you 🩸", style: AppTextStyles.headlineMedium),
            const Gap(8),
            Text(AppStrings.bloodTypePrompt, style: AppTextStyles.bodyMedium),
            const Gap(24),
            Obx(() => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: BloodType.values.map((type) {
                    final isSelected =
                        controller.selectedBloodType.value == type;
                    return ChoiceChip(
                      label: Text(type.label),
                      selected: isSelected,
                      onSelected: (val) => controller.selectBloodType(type),
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color:
                              isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                    );
                  }).toList(),
                )),
            const Gap(32),
            BdenTextField(
              label: 'City',
              hint: 'Douala',
              onChanged: controller.setCity,
            ),
            const Gap(16),
            Text('Region', style: AppTextStyles.labelSmall),
            const Gap(8),
            Obx(() => DropdownButtonFormField<String>(
                  initialValue: controller.region.value.isEmpty
                      ? null
                      : controller.region.value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  hint: Text('Select Region', style: AppTextStyles.bodyMedium),
                  items: controller.regions
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.setRegion(val);
                  },
                )),
            const Gap(48),
            Obx(() => BdenButton(
                  label: 'Done!',
                  isLoading: controller.isLoading.value,
                  onPressed: (controller.selectedBloodType.value != null &&
                          controller.city.value.isNotEmpty &&
                          controller.region.value.isNotEmpty)
                      ? controller.completeSetup
                      : null,
                )),
          ],
        ),
      ),
    );
  }
}
