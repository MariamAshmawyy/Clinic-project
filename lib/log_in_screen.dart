import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'doctor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _selectedRole;

  Future<void> _login() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role before continuing.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', _selectedRole!);

    if (_selectedRole == 'doctor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DoctorDashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select Your Role:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            RadioListTile(
              title: const Text('Patient'),
              value: 'user',
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text('Doctor'),
              value: 'doctor',
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value.toString();
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
