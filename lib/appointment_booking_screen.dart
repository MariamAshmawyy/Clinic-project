import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoctorBookingScreen extends StatefulWidget {
  const DoctorBookingScreen({super.key});

  @override
  _DoctorBookingScreenState createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  DateTime _selectedDay = DateTime.now();
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    "10:00 AM", "11:30 AM", "1:00 PM", "2:30 PM",
    "4:00 PM", "5:30 PM", "7:00 PM", "8:30 PM"
  ];

  void _bookAppointment() {
    if (_selectedTimeSlot == null) {
      Fluttertoast.showToast(msg: "Please select a time slot.", gravity: ToastGravity.BOTTOM);
      return;
    }
    Fluttertoast.showToast(
      msg: "Appointment booked on ${_selectedDay.toLocal().toString().split(' ')[0]} at $_selectedTimeSlot",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Widget
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Select a Time Slot:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _timeSlots.map((slot) => ChoiceChip(
                label: Text(slot),
                selected: _selectedTimeSlot == slot,
                onSelected: (selected) {
                  setState(() {
                    _selectedTimeSlot = selected ? slot : null;
                  });
                },
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[200],
              )).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Confirm Booking',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
