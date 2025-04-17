import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Past Appointments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildAppointmentCard('ENT Consultation', 'March 1, 2025', 'Completed'),
            _buildAppointmentCard('Follow-up Check', 'March 10, 2025', 'Upcoming'),
            const Divider(),
            
            const Text('Prescriptions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPrescriptionCard('Antibiotics', 'Take twice daily for 7 days', 'Download'),
            _buildPrescriptionCard('Allergy Medication', 'Take once daily', 'Download'),
            const Divider(),
            
            const Text('Medical Reports & Diagnoses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildReportCard('Blood Test', 'Normal', 'View Report'),
            _buildReportCard('X-ray', 'No issues detected', 'View Report'),
            const Divider(),
            
            const Text('Doctor’s Notes & Recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDoctorNote('Maintain hydration and avoid allergens.'),
            _buildDoctorNote('Follow-up after 2 weeks if symptoms persist.'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(String type, String date, String status) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(status, style: TextStyle(color: status == 'Completed' ? Colors.green : Colors.orange)),
      ),
    );
  }

  Widget _buildPrescriptionCard(String name, String details, String action) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(details),
        trailing: TextButton(onPressed: () {}, child: Text(action, style: const TextStyle(color: Colors.blue))),
      ),
    );
  }

  Widget _buildReportCard(String test, String result, String action) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(test, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Result: $result'),
        trailing: TextButton(onPressed: () {}, child: Text(action, style: const TextStyle(color: Colors.blue))),
      ),
    );
  }

  Widget _buildDoctorNote(String note) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(note, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}