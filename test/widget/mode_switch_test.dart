import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/app/app.dart';

void main() {
  testWidgets('passenger sets up driver profile and switches to driver mode', (
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

    await tester.tap(find.text('Driver'));
    await tester.pumpAndSettle();
    expect(find.text('Set up Driver Mode'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Suzuki Alto');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc-123');
    await tester.ensureVisible(find.text('Save and continue'));
    await tester.tap(find.text('Save and continue'));
    await tester.pumpAndSettle();

    expect(find.text('Driver dashboard'), findsOneWidget);
  });
}
