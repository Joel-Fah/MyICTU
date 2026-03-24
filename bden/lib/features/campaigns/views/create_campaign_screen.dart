import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/enums/blood_type.dart';
import '../../../../core/enums/campaign_urgency.dart';
import '../controllers/create_campaign_controller.dart';
import '../widgets/blood_type_chip.dart';
import '../../../shared/widgets/bden_text_field.dart';
import '../../../shared/widgets/loading_overlay.dart';

class CreateCampaignScreen extends GetView<CreateCampaignController> {
  const CreateCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('New Campaign'),
            actions: [
              Obx(() => TextButton(
                    onPressed: controller.isFormValid
                        ? () async {
                            final success = await controller.submitCampaign();
                            if (success && context.mounted) {
                              context.pop();
                            }
                          }
                        : null,
                    child: Text('Publish',
                        style: TextStyle(
                          color: controller.isFormValid
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        )),
                  )),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Upload
                GestureDetector(
                  onTap: controller.pickImage,
                  child: DottedBorder(
                    color: AppColors.border,
                    strokeWidth: 2,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(16),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Obx(() {
                        if (controller.coverImage.value != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(controller.coverImage.value!,
                                fit: BoxFit.cover),
                          );
                        }
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(HugeIcons.strokeRoundedImage01,
                                size: 40, color: AppColors.textSecondary),
                            Gap(8),
                            Text('Tap to upload cover image',
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const Gap(24),

                BdenTextField(
                  label: 'Campaign Title',
                  hint: 'e.g. Urgent: O+ needed at Central Hospital',
                  onChanged: (v) => controller.title.value = v,
                ),
                const Gap(16),

                // Urgency Segmented Control (Simple implementation)
                Text('Urgency Level', style: AppTextStyles.labelLarge),
                const Gap(8),
                Obx(() => Row(
                      children: CampaignUrgency.values.map((u) {
                        final isSelected = controller.urgency.value == u;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => controller.urgency.value = u,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? u.color.withOpacity(0.1)
                                    : Colors.transparent,
                                border: Border.all(
                                    color: isSelected
                                        ? u.color
                                        : AppColors.border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(u.label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? u.color
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                const Gap(16),

                BdenTextField(
                  label: 'Description',
                  hint: 'Tell donors why this is important...',
                  maxLines: 4,
                  onChanged: (v) => controller.description.value = v,
                ),
                const Gap(16),

                Row(
                  children: [
                    Expanded(
                      child: BdenTextField(
                        label: 'City',
                        onChanged: (v) => controller.city.value = v,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: BdenTextField(
                        label: 'Region',
                        onChanged: (v) => controller.region.value = v,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                BdenTextField(
                  label: 'Address',
                  onChanged: (v) => controller.address.value = v,
                ),
                const Gap(24),

                Text('Units Needed', style: AppTextStyles.labelLarge),
                const Gap(8),
                Obx(() => Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => controller.unitsNeeded.value > 1
                              ? controller.unitsNeeded.value--
                              : null,
                        ),
                        Text('${controller.unitsNeeded.value}',
                            style: AppTextStyles.headlineMedium),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => controller.unitsNeeded.value++,
                        ),
                      ],
                    )),
                const Gap(24),

                Text('Blood Types Needed', style: AppTextStyles.labelLarge),
                const Gap(8),
                Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BloodType.values
                          .map((bt) => BloodTypeChip(
                                type: bt,
                                isSelected:
                                    controller.selectedBloodTypes.contains(bt),
                                onTap: () => controller.toggleBloodType(bt),
                              ))
                          .toList(),
                    )),
                const Gap(24),

                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) controller.deadline.value = date;
                  },
                  child: AbsorbPointer(
                    child: Obx(() => BdenTextField(
                          label: 'Deadline',
                          hint: 'Select date',
                          controller: TextEditingController(
                              text: controller.deadline.value
                                      ?.toString()
                                      .split(' ')[0] ??
                                  ''),
                          suffixIcon:
                              const Icon(HugeIcons.strokeRoundedCalendar01),
                        )),
                  ),
                ),

                const Gap(32),
              ],
            ),
          ),
        ),
        Obx(() => controller.isLoading.value
            ? const LoadingOverlay()
            : const SizedBox.shrink()),
      ],
    );
  }
}
