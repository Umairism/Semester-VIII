import 'package:flutter_test/flutter_test.dart';

import 'package:proj2/main.dart';

void main() {
  testWidgets('GestureDetector example smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GestureDetectorExample());

    // Verify initial text is present.
    expect(find.text('Halalala Tu chuti kr'), findsOneWidget);

    // Single tap and wait for double-tap timeout (300ms)
    await tester.tap(find.text('Halalala Tu chuti kr'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Single Click q kia???'), findsOneWidget);

    // Double tap
    await tester.tap(find.text('Single Click q kia???'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Single Click q kia???'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Lo ge ab double b kr dia'), findsOneWidget);

    // Long press
    await tester.longPress(find.text('Lo ge ab double b kr dia'));
    await tester.pumpAndSettle();
    expect(find.text('click ko chor b dy ab'), findsOneWidget);
  });
}

