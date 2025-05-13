import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:new_project/main.dart'; // Import your actual app
import 'package:new_project/appointment_booking_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Book Appointment button (Integration)', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // Launch the actual app
    await tester.pumpWidget(MyApp(initialRoute:"/")); // Replace with your app's entry widget
    //await tester.pumpWidget(DoctorBookingScreen());
    // Wait for any animations or build
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'mariam@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), '1234567');
    await tester.tap(find.text('Login'));
    await tester.pump(Duration(seconds: 30));
    await tester.pumpAndSettle();
    // Verify the button and initial text
    expect(find.text('Clinic Booking'), findsOne);
    //expect(find.text('Appointment booked!'), findsNothing);

    // Tap the button
    //await tester.tap(find.byKey(Key('bookButton')));
    //await tester.pumpAndSettle(); // Allow dialog to appear

    // Check that the confirmation appears
    //expect(find.text('Appointment booked!'), findsOneWidget);
  });
}
