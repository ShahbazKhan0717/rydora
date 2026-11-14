import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/app_exception.dart';
import '../models/driver_profile.dart';
import '../models/vehicle_type.dart';

class DriverRepository {
  DriverRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('driver_profiles').doc(uid);

  Stream<DriverProfile?> watchProfile(String uid) =>
      _doc(uid).snapshots().map((snap) {
        final data = snap.data();
        return data == null ? null : DriverProfile.fromMap(uid, data);
      });

  Future<void> createProfile({
    required String uid,
    required VehicleType vehicleType,
    required String model,
    required String plate,
  }) => guardFirebase<void>(
    () => _doc(uid).set({
      'vehicleType': vehicleType.name,
      'model': model.trim(),
      'plate': plate.trim(),
      'isOnline': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }),
  );

  Future<void> setOnline(String uid, bool online) => guardFirebase<void>(
    () => _doc(
      uid,
    ).update({'isOnline': online, 'updatedAt': FieldValue.serverTimestamp()}),
  );
}
