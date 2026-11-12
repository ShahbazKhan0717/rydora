import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/app/app.dart';

void main() {
  testWidgets('user edits profile name and sees it on Profile tab', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: RydoraApp()));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Demo User'), findsOneWidget);

    await tester.ensureVisible(find.text('Edit profile'));
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Ali Khan');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Ali Khan'), findsOneWidget);
  });
}
