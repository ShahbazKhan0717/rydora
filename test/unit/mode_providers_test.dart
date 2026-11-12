import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/data/models/vehicle_type.dart';
import 'package:rydora/features/profile/application/mode_providers.dart';

void main() {
  test('mode defaults to passenger and can switch', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(appModeProvider), AppMode.passenger);
    container.read(appModeProvider.notifier).setMode(AppMode.driver);
    expect(container.read(appModeProvider), AppMode.driver);
  });

  test('driver setup starts empty and can be saved', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(driverSetupProvider), isNull);
    container
        .read(driverSetupProvider.notifier)
        .save(
          const DriverSetup(
            vehicleType: VehicleType.bike,
            model: 'Honda 125',
            plate: 'ABC-123',
          ),
        );
    expect(container.read(driverSetupProvider)?.vehicleType, VehicleType.bike);
  });
}
