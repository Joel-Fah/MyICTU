import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BdenButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;

  const BdenButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ??
        (isOutlined ? Colors.transparent : AppColors.primary);
    final txtColor =
        textColor ?? (isOutlined ? AppColors.primary : AppColors.surface);
    final borderSide = isOutlined
        ? const BorderSide(color: AppColors.primary, width: 2)
        : BorderSide.none;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: txtColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderSide,
          ),
        ),
        child: isLoading
            ? LoadingAnimationWidget.stretchedDots(color: txtColor, size: 24)
            : Text(label,
                style: AppTextStyles.labelLarge.copyWith(color: txtColor)),
      ),
    ).animate().fadeIn().scale();
  }
}
