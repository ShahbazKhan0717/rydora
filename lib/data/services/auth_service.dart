import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/app_exception.dart';

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User> register({required String email, required String password}) =>
      guardFirebase(() async {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        return cred.user!;
      });

  Future<User> signIn({required String email, required String password}) =>
      guardFirebase(() async {
        final cred = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        return cred.user!;
      });

  Future<void> sendPasswordReset(String email) =>
      guardFirebase(() => _auth.sendPasswordResetEmail(email: email.trim()));

  Future<void> signOut() => _auth.signOut();
}
