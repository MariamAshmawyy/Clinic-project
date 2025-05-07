import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_project/notification_helper.dart';  // import your NotificationHelper
import 'package:firebase_auth/firebase_auth.dart';
class DoctorBookingScreen extends StatefulWidget {
  const DoctorBookingScreen({super.key});

  @override
  _DoctorBookingScreenState createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  late Map<String, List<String>> _slotsPerDay = {};
  String? _selectedDayKey;
  String? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _fetchSlotsForThreeDays();
  }

  Future<void> _fetchSlotsForThreeDays() async {
    final firestore = FirebaseFirestore.instance;
    Map<String, List<String>> fetchedSlots = {};

    for (int i = 0; i < 3; i++) {
      DateTime day = DateTime.now().add(Duration(days: i));
      String key = DateFormat('yyyy-MM-dd').format(day);

      DocumentSnapshot doc = await firestore.collection('doctor_slots').doc(key).get();
      if (doc.exists) {
        List<dynamic> slots = doc['slots'] ?? [];
        fetchedSlots[key] = List<String>.from(slots);
      } else {
        fetchedSlots[key] = [];
      }
    }

    setState(() {
      _slotsPerDay = fetchedSlots;
    });
  }

  void _bookAppointment() {
    if (_selectedTimeSlot == null || _selectedDayKey == null) {
      Fluttertoast.showToast(
        msg: "Please select a day and time slot.",
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    Fluttertoast.showToast(
      msg: "Appointment booked!",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
print(FirebaseAuth.instance.currentUser!.uid);
    // Trigger the notification after booking
    NotificationsHelper().sendNotifications(
      topic: FirebaseAuth.instance.currentUser!.uid, // Use the current user's UID as the topic
      title: 'Appointment Booked',
      body: 'An appointment on $_selectedDayKey at $_selectedTimeSlot is Booked!',
      userId: FirebaseAuth.instance.currentUser!.uid, // You can replace this with actual user ID if required
    );


    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushNamed(
        context,
        '/patient_info',
        arguments: {
          'appointmentDate': DateTime.now().add(Duration(days: _selectedDayKey == 'Today' ? 0 : _selectedDayKey == 'Tomorrow' ? 1 : 2)), // Pass DateTime here directly
          'timeSlot': _selectedTimeSlot,
        },
      );
    });
  }

  String getDayLabel(int index) {
    if (index == 0) return "Today";
    if (index == 1) return "Tomorrow";
    return DateFormat('EEEE, d/M').format(DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _slotsPerDay.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your appointment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  DateTime day = DateTime.now().add(Duration(days: index));
                  String key = DateFormat('yyyy-MM-dd').format(day);
                  List<String> slots = _slotsPerDay[key] ?? [];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getDayLabel(index),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (slots.isEmpty) ...[
                            const Text("No slots available", style: TextStyle(color: Colors.grey)),
                          ],
                          ...slots.map((slot) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDayKey = key;
                                  _selectedTimeSlot = slot;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: _selectedTimeSlot == slot ? Colors.green : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  slot,
                                  style: TextStyle(
                                    color: _selectedTimeSlot == slot ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: slots.isEmpty || _selectedTimeSlot == null
                                ? null
                                : _bookAppointment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Updated to backgroundColor
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Book'),
                          ),
                        ],
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
