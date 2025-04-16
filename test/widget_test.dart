// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodmate/main.dart';
import 'package:moodmate/src/services/storage_service.dart';

void main() {
  testWidgets('App Workflow Test', (WidgetTester tester) async {
    // Setup
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);

    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    // Start App
    await tester.pumpWidget(MoodMateApp(storage: storage));
    await tester.pumpAndSettle();

    // Check Home Screen
    expect(find.text('Wie fühlst du dich heute?'), findsOneWidget);
    expect(find.text('Fantastisch'), findsOneWidget);
    expect(find.text('🤩'), findsOneWidget);

    // Select Mood
    await tester.tap(find.text('Fantastisch'));
    await tester.pumpAndSettle();

    // Check Note Screen
    expect(find.text('🤩 Fantastisch'), findsOneWidget);
    expect(find.text('Möchtest du etwas dazu sagen?'), findsOneWidget);
    expect(find.text('Speichern'), findsOneWidget);

    // Add Note and Save
    await tester.enterText(find.byType(TextField), 'Test Notiz');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    // Check Thank You Screen
    expect(find.text('Danke!'), findsOneWidget);
    expect(find.text('😊'), findsOneWidget);
    expect(find.text('Zurück zum Start'), findsOneWidget);

    // Go Back to Home
    await tester.tap(find.text('Zurück zum Start'));
    await tester.pumpAndSettle();

    // Check History
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    // Verify Entry in History
    expect(find.text('🤩'), findsOneWidget);
    expect(find.text('Fantastisch'), findsOneWidget);
    expect(find.text('Test Notiz'), findsOneWidget);
  });
}
