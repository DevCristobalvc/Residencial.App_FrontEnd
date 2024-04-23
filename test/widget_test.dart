import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dummy widget test', (WidgetTester tester) async {
    // Define a test. The WidgetTester allows building and interacting with widgets in the test environment.
    const widget = MaterialApp(home: Scaffold(body: Text('Dummy Test')));

    // Build our app and trigger a frame.
    await tester.pumpWidget(widget);

    // Verify that the Text widget appears exactly once in the widget tree.
    expect(find.text('Dummy Test'), findsOneWidget);
  });
}
