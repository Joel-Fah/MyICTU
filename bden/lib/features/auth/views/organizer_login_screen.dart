import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/bden_button.dart';
import '../../../../shared/widgets/bden_text_field.dart';
import '../controllers/auth_controller.dart';

class OrganizerLoginScreen extends GetView<AuthController> {
  const OrganizerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Health Center Sign In',
                  style: AppTextStyles.headlineMedium),
              const Gap(32),
              BdenTextField(
                label: 'Email',
                controller: emailCtrl,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(16),
              BdenTextField(
                label: 'Password',
                controller: passCtrl,
                validator: Validators.password,
                obscureText: true,
              ),
              const Gap(24),
              Obx(() => Column(
                    children: [
                      if (controller.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(controller.errorMessage.value,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.error)),
                        ),
                      BdenButton(
                        label: 'Sign in',
                        isLoading: controller.isLoading.value,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.loginWithEmail(
                                emailCtrl.text.trim(), passCtrl.text.trim());
                          }
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
