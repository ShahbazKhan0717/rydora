import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/data/models/app_user.dart';
import 'package:rydora/data/models/driver_profile.dart';
import 'package:rydora/data/models/vehicle_type.dart';

void main() {
  test('AppUser.fromMap reads fields and applies defaults', () {
    final user = AppUser.fromMap('u1', {'name': 'Ali', 'email': 'a@b.com'});
    expect(user.uid, 'u1');
    expect(user.name, 'Ali');
    expect(user.phone, '');
    expect(AppUser.fromMap('u2', {}).name, 'User');
  });

  test('DriverProfile.fromMap parses vehicle type and falls back to car', () {
    final bike = DriverProfile.fromMap('d1', {
      'vehicleType': 'bike',
      'model': 'Honda 125',
      'plate': 'ABC-1',
      'isOnline': true,
    });
    expect(bike.vehicleType, VehicleType.bike);
    expect(bike.isOnline, isTrue);
    expect(DriverProfile.fromMap('d2', {}).vehicleType, VehicleType.car);
  });
}
