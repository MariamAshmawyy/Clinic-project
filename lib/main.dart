import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import 'auth_screen.dart';
import 'home_screen.dart';
import 'doctor_dashboard.dart';
import 'doctor_availability_screen.dart';
import 'medical_history_screen.dart';
import 'profile_settings_screen.dart';
import 'appointment_booking_screen.dart';

// Firebase config
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final user = FirebaseAuth.instance.currentUser;

  String initialRoute;
  if (user != null && user.email == 'drtarek@clinic.com') {
    initialRoute = '/doctor_dashboard';
  } else if (user != null) {
    initialRoute = '/home';
  } else {
    initialRoute = '/';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ENT Clinic App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/doctor_dashboard': (context) => const DoctorDashboardScreen(),
        '/appointment': (context) => const DoctorBookingScreen(),
        '/availability': (context) => const DoctorAvailabilityScreen(),
        '/history': (context) => const MedicalHistoryScreen(),
        '/profile': (context) => const ProfileSettingsScreen(),
      },
    );
  }
}
