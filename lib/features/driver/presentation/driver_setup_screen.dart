import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/rydora_button.dart';
import '../../../core/widgets/rydora_text_field.dart';
import '../../../data/models/vehicle_type.dart';
import '../../profile/application/mode_providers.dart';

class DriverSetupScreen extends ConsumerStatefulWidget {
  const DriverSetupScreen({super.key});

  @override
  ConsumerState<DriverSetupScreen> createState() => _DriverSetupScreenState();
}

class _DriverSetupScreenState extends ConsumerState<DriverSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _model = TextEditingController();
  final _plate = TextEditingController();
  VehicleType _type = VehicleType.car;

  @override
  void dispose() {
    _model.dispose();
    _plate.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(driverSetupProvider.notifier)
        .save(
          DriverSetup(
            vehicleType: _type,
            model: _model.text.trim(),
            plate: _plate.text.trim().toUpperCase(),
          ),
        );
    ref.read(appModeProvider.notifier).setMode(AppMode.driver);
    context.go(AppRoutes.driverHome);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up Driver Mode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.passengerHome),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Text(
                    'Demo only: no documents are checked. '
                    'Driver verification is simulated.',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Your vehicle',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<VehicleType>(
                    segments: [
                      for (final t in VehicleType.values)
                        ButtonSegment(
                          value: t,
                          icon: Icon(
                            t == VehicleType.car
                                ? Icons.directions_car
                                : Icons.two_wheeler,
                          ),
                          label: Text(t.label),
                        ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (s) => setState(() => _type = s.first),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                RydoraTextField(
                  label: 'Vehicle model (e.g. Suzuki Alto)',
                  controller: _model,
                  validator: (v) => Validators.required(v, 'Vehicle model'),
                  prefixIcon: Icons.directions_car_outlined,
                ),
                const SizedBox(height: AppSpacing.md),
                RydoraTextField(
                  label: 'Number plate',
                  controller: _plate,
                  validator: (v) => Validators.required(v, 'Number plate'),
                  prefixIcon: Icons.pin_outlined,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.lg),
                RydoraButton(label: 'Save and continue', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
