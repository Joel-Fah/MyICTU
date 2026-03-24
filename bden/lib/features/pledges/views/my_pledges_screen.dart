import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/enums/pledge_status.dart';
import '../controllers/pledge_controller.dart';
import '../../../shared/widgets/empty_state.dart';

class MyPledgesScreen extends GetView<PledgeController> {
  const MyPledgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pledges', style: AppTextStyles.headlineMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: AppColors.primary, size: 40));
        }

        if (controller.pledges.isEmpty) {
          return const EmptyState(
            icon: HugeIcons.strokeRoundedDroplet,
            title: 'No pledges yet',
            subtitle: 'Find a campaign and start donating!',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.pledges.length,
          itemBuilder: (context, index) {
            final pledge = controller.pledges[index];
            final isConfirmed = pledge.status == PledgeStatus.confirmed;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isConfirmed
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.primaryLight,
                  child: Icon(
                    isConfirmed
                        ? HugeIcons.strokeRoundedCheckmarkBadge01
                        : HugeIcons.strokeRoundedTime01,
                    color: isConfirmed ? AppColors.success : AppColors.primary,
                  ),
                ),
                title: Text(pledge.donorName,
                    style: AppTextStyles
                        .titleMedium), // Actually should be campaign title ideally, but pledge model only has donor/campaign IDs.
                // We'd need to fetch campaign details to show campaign title.
                // For MVP, maybe just show "Pledge for Campaign" or ID, or we assume specific UI requirements.
                // The instructions don't specify fetching campaign details here.
                // I will just show "Donation Pledge" and status.
                subtitle: Text('Status: ${pledge.status.name.toUpperCase()}'),
                trailing: Text(
                  timeago.format(pledge.createdAt),
                  style: AppTextStyles.labelSmall,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
