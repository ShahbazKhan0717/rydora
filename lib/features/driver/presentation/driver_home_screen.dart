import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snack.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/rydora_button.dart';
import '../../../data/models/driver_profile.dart';
import '../../../data/providers.dart';
import '../../profile/presentation/profile_tab.dart';
import '../../profile/presentation/widgets/mode_switch_card.dart';

class DriverHomeScreen extends ConsumerWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(driverProfileProvider);
    return profile.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => const Scaffold(
        body: SafeArea(
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'Something went wrong',
            message:
                'Could not load your driver profile. Check your connection.',
          ),
        ),
      ),
      data: (p) => p == null ? const _NeedsSetup() : _DriverShell(profile: p),
    );
  }
}

class _NeedsSetup extends StatelessWidget {
  const _NeedsSetup();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Expanded(
                child: EmptyState(
                  icon: Icons.drive_eta,
                  title: 'Driver Mode is not set up',
                  message: 'Add your vehicle details to start driving.',
                ),
              ),
              RydoraButton(
                label: 'Set up Driver Mode',
                onPressed: () => context.go(AppRoutes.driverSetup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriverShell extends StatefulWidget {
  const _DriverShell({required this.profile});

  final DriverProfile profile;

  @override
  State<_DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<_DriverShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            _DashboardTab(profile: p),
            EmptyState(
              icon: p.isOnline
                  ? Icons.hourglass_empty
                  : Icons.power_settings_new,
              title: p.isOnline ? 'No requests yet' : 'You are offline',
              message: p.isOnline
                  ? 'Passenger requests arrive in Phase 6.'
                  : 'Go online on the Dashboard to see requests.',
            ),
            const ProfileTab(isDriver: true),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Requests'),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab({required this.profile});

  final DriverProfile profile;

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool value) async {
    try {
      await ref.read(driverRepositoryProvider).setOnline(profile.uid, value);
    } on AppException catch (e) {
      if (context.mounted) showSnack(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final online = profile.isOnline;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Driver dashboard',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const ModeSwitchCard(),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: SwitchListTile(
            title: Text(online ? 'You are online' : 'You are offline'),
            subtitle: Text(
              online
                  ? 'Ride requests will appear here.'
                  : 'Go online to receive ride requests.',
            ),
            value: online,
            onChanged: (v) => _toggle(context, ref, v),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(
              child: _StatCard(label: 'Today (demo)', value: 'Rs 0'),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(label: 'Trips', value: '0'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
