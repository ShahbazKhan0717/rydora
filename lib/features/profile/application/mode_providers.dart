import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/vehicle_type.dart';

enum AppMode { passenger, driver }

class DriverSetup {
  const DriverSetup({
    required this.vehicleType,
    required this.model,
    required this.plate,
  });

  final VehicleType vehicleType;
  final String model;
  final String plate;
}

class AppModeNotifier extends Notifier<AppMode> {
  @override
  AppMode build() => AppMode.passenger;

  void setMode(AppMode mode) => state = mode;
}

/// null means the driver profile is not completed yet.
/// In-memory demo only. Phase 4/6 moves this to Firestore.
class DriverSetupNotifier extends Notifier<DriverSetup?> {
  @override
  DriverSetup? build() => null;

  void save(DriverSetup setup) => state = setup;
}

class DriverOnlineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setOnline(bool value) => state = value;
}

final appModeProvider = NotifierProvider<AppModeNotifier, AppMode>(
  AppModeNotifier.new,
);

final driverSetupProvider = NotifierProvider<DriverSetupNotifier, DriverSetup?>(
  DriverSetupNotifier.new,
);

final driverOnlineProvider = NotifierProvider<DriverOnlineNotifier, bool>(
  DriverOnlineNotifier.new,
);
