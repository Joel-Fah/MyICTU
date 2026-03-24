import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/constants/app_colors.dart';

class OrganizerShell extends StatelessWidget {
  final Widget child;
  const OrganizerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (idx) => _onItemTapped(idx, context),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedDashboardSquare01,
                color: AppColors.textSecondary),
            selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedDashboardSquare01,
                color: AppColors.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedNotification01,
                color: AppColors.textSecondary),
            selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedNotification01,
                color: AppColors.primary),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                color: AppColors.textSecondary),
            selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/organizer/dashboard')) return 0;
    if (location.startsWith('/organizer/notifications')) return 1;
    if (location.startsWith('/organizer/profile')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/organizer/dashboard');
        break;
      case 1:
        context.go('/organizer/notifications');
        break;
      case 2:
        context.go('/organizer/profile');
        break;
    }
  }
}
