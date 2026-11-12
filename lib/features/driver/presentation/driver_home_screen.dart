import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../profile/application/mode_providers.dart';
import '../../profile/presentation/profile_tab.dart';
import '../../profile/presentation/widgets/mode_switch_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: const [
            _DashboardTab(),
            _RequestsTab(),
            ProfileTab(isDriver: true),
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
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final online = ref.watch(driverOnlineProvider);

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
            onChanged: (v) =>
                ref.read(driverOnlineProvider.notifier).setOnline(v),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Expanded(
              child: _StatCard(label: 'Today (demo)', value: 'Rs 0'),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
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

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(driverOnlineProvider);
    return EmptyState(
      icon: online ? Icons.hourglass_empty : Icons.power_settings_new,
      title: online ? 'No requests yet' : 'You are offline',
      message: online
          ? 'Passenger requests arrive in Phase 6.'
          : 'Go online on the Dashboard to see requests.',
    );
  }
}
