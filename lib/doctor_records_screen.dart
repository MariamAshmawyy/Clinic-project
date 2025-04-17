import 'package:flutter/material.dart';

class DoctorRecordsScreen extends StatefulWidget {
  const DoctorRecordsScreen({super.key});

  @override
  _DoctorRecordsScreenState createState() => _DoctorRecordsScreenState();
}

class _DoctorRecordsScreenState extends State<DoctorRecordsScreen> {
  final List<Map<String, String>> patientRecords = [
    {'name': 'John Doe', 'condition': 'Flu', 'lastVisit': '10 May 2024'},
    {'name': 'Jane Smith', 'condition': 'Allergy', 'lastVisit': '5 May 2024'},
    {'name': 'Alice Johnson', 'condition': 'Migraine', 'lastVisit': '1 May 2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Records'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: patientRecords.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(patientRecords[index]['name']!),
                subtitle: Text(
                  'Condition: ${patientRecords[index]['condition']!}\nLast Visit: ${patientRecords[index]['lastVisit']!}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                  onPressed: () {
                    _viewPatientDetails(context, patientRecords[index]);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _viewPatientDetails(BuildContext context, Map<String, String> patient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Patient: ${patient['name']}'),
          content: Text(
            'Condition: ${patient['condition']}\nLast Visit: ${patient['lastVisit']}\n\nMedical Notes: Lorem ipsum dolor sit amet...'
          ),
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