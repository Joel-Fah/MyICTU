import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/bden_button.dart';
import '../controllers/auth_controller.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;
  final _auth = Get.find<AuthController>();

  void _select(UserRole role) {
    setState(() => _selectedRole = role);
  }

  Future<void> _continue() async {
    if (_selectedRole == null) return;
    await _auth.updateRole(_selectedRole!);
    if (mounted) context.push(AppRoutes.onboarding);
  }

  Widget _buildCard({
    required UserRole role,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => _select(role),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            HugeIcon(
                icon: icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 48),
            const Gap(16),
            Text(title,
                style: AppTextStyles.titleLarge
                    .copyWith(color: isSelected ? AppColors.primary : null)),
            const Gap(8),
            Text(subtitle,
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(24),
              Text("What brings you here?",
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center),
              const Gap(48),
              _buildCard(
                role: UserRole.donor,
                icon: HugeIcons.strokeRoundedDroplet,
                title: "I want to donate",
                subtitle: "Find campaigns and pledge your blood",
              ),
              const Gap(16),
              _buildCard(
                role: UserRole.organizer,
                icon: HugeIcons.strokeRoundedHospital01,
                title: "I'm a health center",
                subtitle: "Run campaigns and track donors",
              ),
              const Spacer(),
              BdenButton(
                label: 'Continue',
                onPressed: _selectedRole != null ? _continue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
