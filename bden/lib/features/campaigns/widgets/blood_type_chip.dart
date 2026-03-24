import 'package:flutter/material.dart';
import '../../../../core/enums/blood_type.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BloodTypeChip extends StatelessWidget {
  final BloodType type;
  final bool isSelected;
  final VoidCallback? onTap;

  const BloodTypeChip(
      {super.key, required this.type, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          type.label,
          style: AppTextStyles.labelLarge.copyWith(
            color: isSelected ? AppColors.surface : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
