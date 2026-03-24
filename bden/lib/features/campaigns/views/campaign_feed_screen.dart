import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/enums/blood_type.dart';
import '../controllers/campaign_feed_controller.dart';
import '../widgets/campaign_card.dart';
import '../../../shared/widgets/empty_state.dart';

class CampaignFeedScreen extends GetView<CampaignFeedController> {
  const CampaignFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.feedTitle, style: AppTextStyles.headlineMedium),
        actions: [
          IconButton(
            icon: const Badge(
                child: HugeIcon(
                    icon: HugeIcons.strokeRoundedNotification01,
                    color: AppColors.textPrimary)),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          const Gap(8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search campaigns...',
                prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: AppColors.textSecondary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => Row(
                  children: [
                    ...BloodType.values.map((bt) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(bt.label),
                            selected:
                                controller.selectedBloodTypes.contains(bt),
                            onSelected: (_) =>
                                controller.toggleBloodTypeFilter(bt),
                            selectedColor: AppColors.primaryLight,
                            labelStyle: TextStyle(
                                color:
                                    controller.selectedBloodTypes.contains(bt)
                                        ? AppColors.primary
                                        : AppColors.textSecondary),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: controller.selectedBloodTypes
                                            .contains(bt)
                                        ? AppColors.primary
                                        : AppColors.border)),
                            showCheckmark: false,
                          ),
                        )),
                  ],
                )),
          ),
          const Gap(16),

          // Campaign List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: LoadingAnimationWidget.inkDrop(
                      color: AppColors.primary, size: 40),
                );
              }

              final campaigns = controller.filteredCampaigns;
              if (campaigns.isEmpty) {
                return const EmptyState(
                  icon: HugeIcons.strokeRoundedSearch01,
                  title: 'No campaigns found',
                  subtitle: 'Try adjusting your filters or search query.',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // Stream handles updates, just delay for UX
                  await Future.delayed(const Duration(seconds: 1));
                },
                color: AppColors.primary,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) =>
                      CampaignCard(campaign: campaigns[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
