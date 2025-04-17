import 'package:flutter/material.dart';
import 'doctor_slots_screen.dart';
import 'doctor_records_screen.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome, Doctor!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Manage your availability and patient records efficiently.'),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // Make grid responsive
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16, // Adds horizontal spacing between items
              mainAxisSpacing: 16,  // Adds vertical spacing between items
              children: [
                _buildGridItem(context, 'Manage Slots', Icons.calendar_today, const DoctorSlotsScreen()),
                _buildGridItem(context, 'Patient Records', Icons.folder_shared, const DoctorRecordsScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Improved grid item with pushReplacement to avoid going back to the dashboard
  Widget _buildGridItem(BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
