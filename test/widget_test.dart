import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart'; // Make sure this matches your actual app name

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // ✅ Use ECGApp instead of MyApp

    // Example placeholder test (replace with your actual UI test)
    expect(find.byType(MaterialApp), findsOneWidget);

    // Add your actual test logic if needed
  });
}
