import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/app_exception.dart';
import '../models/app_user.dart';

class UserRepository {
  UserRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  Stream<AppUser?> watchUser(String uid) => _doc(uid).snapshots().map((snap) {
    final data = snap.data();
    return data == null ? null : AppUser.fromMap(uid, data);
  });

  /// Creates users/{uid} if it does not exist yet. Safe to call repeatedly.
  Future<void> ensureProfile({
    required String uid,
    required String email,
    required String name,
    String phone = '',
  }) => guardFirebase<void>(() async {
    final ref = _doc(uid);
    final snap = await ref.get();
    if (snap.exists) return;
    await ref.set({
      'name': name.trim(),
      'email': email,
      'phone': phone.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  });

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
  }) => guardFirebase<void>(
    () => _doc(uid).update({
      'name': name.trim(),
      'phone': phone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }),
  );
}
