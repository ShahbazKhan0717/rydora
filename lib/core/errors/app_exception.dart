import 'package:firebase_auth/firebase_auth.dart';

class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Runs a Firebase call and converts failures into friendly [AppException]s.
Future<T> guardFirebase<T>(Future<T> Function() action) async {
  try {
    return await action().timeout(
      const Duration(seconds: 20),
      onTimeout: () => throw const AppException(
        'Network problem. Check your connection and try again.',
      ),
    );
  } on AppException {
    rethrow;
  } on FirebaseAuthException catch (e) {
    throw AppException(_authMessage(e.code));
  } on FirebaseException catch (e) {
    throw AppException(_storeMessage(e.code));
  }
}

String _authMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'That email address is not valid.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'email-already-in-use':
      return 'An account already exists for this email.';
    case 'weak-password':
      return 'Choose a stronger password (6+ characters).';
    case 'network-request-failed':
      return 'Network problem. Check your connection.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later.';
    case 'operation-not-allowed':
      return 'Email sign-in is not enabled for this project.';
    default:
      return 'Authentication failed. Please try again.';
  }
}

String _storeMessage(String code) {
  switch (code) {
    case 'permission-denied':
      return 'You do not have permission to do that.';
    case 'unavailable':
    case 'deadline-exceeded':
      return 'Network problem. Check your connection.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
