import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/mode_providers.dart';

class ModeSwitchCard extends ConsumerWidget {
  const ModeSwitchCard({super.key});

  void _onChanged(BuildContext context, WidgetRef ref, AppMode target) {
    final notifier = ref.read(appModeProvider.notifier);
    if (target == AppMode.passenger) {
      notifier.setMode(AppMode.passenger);
      context.go(AppRoutes.passengerHome);
      return;
    }
    if (ref.read(driverSetupProvider) == null) {
      context.go(AppRoutes.driverSetup);
      return;
    }
    notifier.setMode(AppMode.driver);
    context.go(AppRoutes.driverHome);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Switch mode',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AppMode>(
                segments: const [
                  ButtonSegment(
                    value: AppMode.passenger,
                    icon: Icon(Icons.person),
                    label: Text('Passenger'),
                  ),
                  ButtonSegment(
                    value: AppMode.driver,
                    icon: Icon(Icons.drive_eta),
                    label: Text('Driver'),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (s) => _onChanged(context, ref, s.first),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
