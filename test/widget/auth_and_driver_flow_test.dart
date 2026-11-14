import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/app/app.dart';
import 'package:rydora/data/providers.dart';

Widget _app(MockFirebaseAuth auth, FakeFirebaseFirestore db) => ProviderScope(
  overrides: [
    firebaseAuthProvider.overrideWithValue(auth),
    firestoreProvider.overrideWithValue(db),
  ],
  child: const RydoraApp(),
);

/// Tall test screen so long scrolling lists are fully built.
void _tallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

MockFirebaseAuth _signedIn() => MockFirebaseAuth(
  signedIn: true,
  mockUser: MockUser(uid: 'u1', email: 'ali@example.com'),
);

Future<FakeFirebaseFirestore> _seededDb() async {
  final db = FakeFirebaseFirestore();
  await db.collection('users').doc('u1').set({
    'name': 'Ali Khan',
    'email': 'ali@example.com',
    'phone': '',
  });
  return db;
}

Future<void> _pastSplash(WidgetTester t) async {
  await t.pump(const Duration(seconds: 3));
  await t.pumpAndSettle();
}

Future<void> _openProfileTab(WidgetTester t) async {
  await t.tap(find.text('Profile'));
  await t.pumpAndSettle();
}

void main() {
  testWidgets('register creates account and profile, then log out', (
    tester,
  ) async {
    _tallScreen(tester);
    final auth = MockFirebaseAuth();
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(_app(auth, db));
    await _pastSplash(tester);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ali Khan');
    await tester.enterText(fields.at(1), 'ali@example.com');
    await tester.enterText(fields.at(2), '03001234567');
    await tester.enterText(fields.at(3), '123456');
    await tester.enterText(fields.at(4), '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Ali Khan'), findsOneWidget);
    final doc = await db.collection('users').doc(auth.currentUser!.uid).get();
    expect(doc.data()?['name'], 'Ali Khan');

    await _openProfileTab(tester);
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('passenger becomes driver and goes online', (tester) async {
    _tallScreen(tester);
    final db = await _seededDb();
    await tester.pumpWidget(_app(_signedIn(), db));
    await _pastSplash(tester);
    expect(find.text('Hello, Ali Khan'), findsOneWidget);

    await _openProfileTab(tester);
    await tester.tap(find.text('Driver'));
    await tester.pumpAndSettle();
    expect(find.text('Set up Driver Mode'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Suzuki Alto');
    await tester.enterText(fields.at(1), 'abc-123');
    await tester.tap(find.widgetWithText(FilledButton, 'Save and continue'));
    await tester.pumpAndSettle();
    expect(find.text('Driver dashboard'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('You are online'), findsOneWidget);

    final doc = await db.collection('driver_profiles').doc('u1').get();
    expect(doc.data()?['isOnline'], true);
    expect(doc.data()?['vehicleType'], 'car');
    expect(doc.data()?['plate'], 'ABC-123');
  });

  testWidgets('edit profile saves to Firestore and updates the screen', (
    tester,
  ) async {
    _tallScreen(tester);
    final db = await _seededDb();
    await tester.pumpWidget(_app(_signedIn(), db));
    await _pastSplash(tester);

    await _openProfileTab(tester);
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Ali Raza');
    await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Ali Raza'), findsOneWidget);
    final doc = await db.collection('users').doc('u1').get();
    expect(doc.data()?['name'], 'Ali Raza');
  });
}
