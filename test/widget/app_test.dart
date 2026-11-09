import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/app/app.dart';

void main() {
  testWidgets('splash shows RYDORA, then moves to welcome screen', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: RydoraApp()));

    expect(find.text('RYDORA'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to RYDORA'), findsOneWidget);
  });
}
