import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/vehicle_type.dart';
import '../application/mode_providers.dart';
import 'widgets/mode_switch_card.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key, required this.isDriver});

  final bool isDriver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final setup = ref.watch(driverSetupProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const Center(
          child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          isDriver ? 'Demo Driver' : 'Demo Passenger',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(
          'Demo account. Real profile arrives with Firebase (Phase 4).',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (isDriver && setup != null) ...[
          Card(
            child: ListTile(
              leading: Icon(
                setup.vehicleType == VehicleType.car
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                color: AppColors.primary,
              ),
              title: Text('${setup.vehicleType.label} - ${setup.model}'),
              subtitle: Text('Plate: ${setup.plate}'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const ModeSwitchCard(),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
          onPressed: () {
            ref.invalidate(appModeProvider);
            ref.invalidate(driverSetupProvider);
            ref.invalidate(driverOnlineProvider);
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }
}
