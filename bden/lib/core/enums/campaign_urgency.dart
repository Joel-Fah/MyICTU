import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum CampaignUrgency {
  routine,
  urgent,
  critical;

  String get label {
    switch (this) {
      case routine:
        return 'Routine';
      case urgent:
        return 'Urgent';
      case critical:
        return 'Critical';
    }
  }

  Color get color {
    switch (this) {
      case routine:
        return AppColors.urgencyRoutine;
      case urgent:
        return AppColors.urgencyUrgent;
      case critical:
        return AppColors.urgencyCritical;
    }
  }
}
