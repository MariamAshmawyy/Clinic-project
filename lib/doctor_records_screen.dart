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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/doctor_dashboard');
          },
        ),
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
              final docRef = docs[index].reference;

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
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _viewPatientDetails(context, data, docRef),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushReplacementNamed(context, '/doctor_dashboard'),
        icon: const Icon(Icons.dashboard),
        label: const Text('Back to Dashboard'),
      ),
    );
  }

  /// Show editable patient details
  void _viewPatientDetails(
      BuildContext context,
      Map<String, dynamic> patient,
      DocumentReference docRef,
      ) {
    final TextEditingController conditionController =
    TextEditingController(text: patient['illness'] ?? '');
    final TextEditingController medicationsController =
    TextEditingController(text: patient['medications'] ?? '');

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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${patient['email'] ?? '-'}'),
                const SizedBox(height: 10),
                Text('Last Visit: $formattedDate'),
                const SizedBox(height: 10),
                TextField(
                  controller: conditionController,
                  decoration: const InputDecoration(
                    labelText: 'Condition',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: medicationsController,
                  decoration: const InputDecoration(
                    labelText: 'Medications',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Text('Age: ${patient['age'] ?? '-'}'),
                Text('Gender: ${patient['gender'] ?? '-'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await docRef.update({
                    'illness': conditionController.text.trim(),
                    'medications': medicationsController.text.trim(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Patient record updated successfully')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update record: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
