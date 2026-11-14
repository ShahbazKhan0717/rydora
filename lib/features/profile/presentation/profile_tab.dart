import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/vehicle_type.dart';
import '../../../data/providers.dart';
import '../application/mode_providers.dart';
import 'widgets/mode_switch_card.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key, required this.isDriver});

  final bool isDriver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider).value;
    final driver = ref.watch(driverProfileProvider).value;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const Center(
          child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          user?.name ?? '...',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(
          user?.email ?? '',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
        Text(
          isDriver ? 'Driver Mode' : 'Passenger Mode',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (isDriver && driver != null) ...[
          Card(
            child: ListTile(
              leading: Icon(
                driver.vehicleType == VehicleType.car
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                color: AppColors.primary,
              ),
              title: Text('${driver.vehicleType.label} - ${driver.model}'),
              subtitle: Text('Plate: ${driver.plate}'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const ModeSwitchCard(),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.settings),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help and Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.help),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
          onPressed: () async {
            ref.invalidate(appModeProvider);
            await ref.read(authServiceProvider).signOut();
          },
        ),
      ],
    );
  }
}
