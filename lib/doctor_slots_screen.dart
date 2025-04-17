import 'package:flutter/material.dart';

class DoctorSlotsScreen extends StatefulWidget {
  const DoctorSlotsScreen({super.key});

  @override
  _DoctorSlotsScreenState createState() => _DoctorSlotsScreenState();
}

class _DoctorSlotsScreenState extends State<DoctorSlotsScreen> {
  List<String> availableSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
  ];

  void _addSlot(String slot) {
    setState(() {
      availableSlots.add(slot);
    });
  }

  void _removeSlot(int index) {
    setState(() {
      availableSlots.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController slotController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Slots'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: slotController,
              decoration: const InputDecoration(
                labelText: 'Enter Slot (e.g., 05:00 PM - 06:00 PM)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (slotController.text.isNotEmpty) {
                  _addSlot(slotController.text);
                  slotController.clear();
                }
              },
              child: const Text('Add Slot'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Slots:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: availableSlots.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(availableSlots[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSlot(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
