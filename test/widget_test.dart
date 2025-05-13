import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_project/main.dart';  // Import your main app

void main() {
  testWidgets('Test Book Appointment button', (WidgetTester tester) async {
    // Build the widget tree with the screen containing the button and text
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Choose your appointment:', key: Key('appointmentText')),
              ElevatedButton(
                key: Key('bookButton'),
                onPressed: () {
                  // Simulate booking the appointment by displaying a confirmation message
                  showDialog(
                    context: tester.element(find.byType(ElevatedButton)),
                    builder: (_) => AlertDialog(
                      content: Text('Appointment booked!'),
                    ),
                  );
                },
                child: const Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the initial state: The "Book Appointment" button is displayed
    expect(find.text('Book Appointment'), findsOneWidget);
    expect(find.text('Appointment booked!'), findsNothing); // No confirmation yet

    // Tap the "Book Appointment" button and trigger a frame
    await tester.tap(find.byKey(Key('bookButton')));
    await tester.pump(); // Rebuild after the tap to show the dialog

    // Verify that the confirmation message is shown after the button click
    expect(find.text('Appointment booked!'), findsOneWidget); // Confirmation message should appear
  });
}
