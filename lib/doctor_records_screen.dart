import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorRecordsScreen extends StatelessWidget {
  const DoctorRecordsScreen({super.key});

  /// Fetches all patient appointments using a collectionGroup query
  Stream<QuerySnapshot> _getAppointments() {
    return FirebaseFirestore.instance
        .collectionGroup('appointments') // Works with patients/{uid}/appointments
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Records'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No patient records found."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final name = data['patientName'] ?? 'Unknown';
              final illness = data['illness'] ?? 'Not specified';

              DateTime? date;
              try {
                date = DateTime.parse(data['appointmentDate']);
              } catch (_) {
                date = null;
              }

              final formattedDate = date != null
                  ? "${date.day}/${date.month}/${date.year}"
                  : "Invalid Date";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text('Condition: $illness\nLast Visit: $formattedDate'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                    onPressed: () => _viewPatientDetails(context, data),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Show full patient details in a dialog
  void _viewPatientDetails(BuildContext context, Map<String, dynamic> patient) {
    DateTime? date;
    try {
      date = DateTime.parse(patient['appointmentDate']);
    } catch (_) {
      date = null;
    }

    final formattedDate =
    date != null ? date.toLocal().toString().split(" ")[0] : "Invalid Date";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Patient: ${patient['patientName'] ?? "Unknown"}'),
          content: Text('''
Email: ${patient['email'] ?? '-'}
Condition: ${patient['illness'] ?? 'N/A'}
Last Visit: $formattedDate
Medications: ${patient['medications'] ?? 'None'}
Age: ${patient['age'] ?? '-'}
Gender: ${patient['gender'] ?? '-'}
'''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
