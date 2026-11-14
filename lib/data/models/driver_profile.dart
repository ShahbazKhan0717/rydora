import 'vehicle_type.dart';

class DriverProfile {
  const DriverProfile({
    required this.uid,
    required this.vehicleType,
    required this.model,
    required this.plate,
    required this.isOnline,
  });

  factory DriverProfile.fromMap(String uid, Map<String, dynamic> map) =>
      DriverProfile(
        uid: uid,
        vehicleType: VehicleType.values.firstWhere(
          (t) => t.name == map['vehicleType'],
          orElse: () => VehicleType.car,
        ),
        model: (map['model'] as String?) ?? '',
        plate: (map['plate'] as String?) ?? '',
        isOnline: (map['isOnline'] as bool?) ?? false,
      );

  final String uid;
  final VehicleType vehicleType;
  final String model;
  final String plate;
  final bool isOnline;
}
