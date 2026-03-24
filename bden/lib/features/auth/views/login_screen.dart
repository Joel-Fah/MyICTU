import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/google_sign_in_button.dart';

import '../../../../core/utils/ui_feedback.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Top Half
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HugeIcon(
                          icon: HugeIcons.strokeRoundedDroplet,
                          color: AppColors.primary,
                          size: 64)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.2),
                  const Gap(16),
                  Text(AppStrings.appName, style: AppTextStyles.displayLarge),
                  Text(AppStrings.tagline, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ),

          // Bottom Half Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Welcome back 👋",
                        style: AppTextStyles.titleLarge,
                        textAlign: TextAlign.center),
                    const Gap(32),
                    Obx(() => GoogleSignInButton(
                          isLoading: controller.isLoading.value,
                          onPressed: () async {
                            await controller.loginWithGoogle();
                            if (controller.errorMessage.isNotEmpty) {
                              if (context.mounted) {
                                UIFeedback.showSnackBar(
                                  context,
                                  controller.errorMessage.value,
                                  isError: true,
                                );
                              }
                            }
                          },
                        )),
                    const Gap(24),
                    const Row(children: [
                      Expanded(child: Divider()),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(AppStrings.orContinueWith)),
                      Expanded(child: Divider()),
                    ]),
                    const Gap(24),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.organizerLogin),
                      child: Text(AppStrings.orgSignIn,
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3),
          ),
        ],
      ),
    );
  }
}
