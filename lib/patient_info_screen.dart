import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientInfoScreen extends StatefulWidget {
  const PatientInfoScreen({super.key});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _age;
  String? _gender;
  String? _illness;
  String? _medications;
  bool _isSubmitting = false;

  late DateTime _appointmentDate;
  late String _timeSlot;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _appointmentDate = args['appointmentDate'];
    _timeSlot = args['timeSlot'];
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No logged-in user");

      final uid = user.uid;
      final email = user.email!;
      final appointmentId = "${_appointmentDate.toIso8601String()}_${_timeSlot.replaceAll(":", "-").replaceAll(" ", "_")}";

      final patientRef = FirebaseFirestore.instance
          .collection('patients')
          .doc(uid); // ✅ matches Firestore rule

      // Optional: save patient's email
      await patientRef.set({'email': email}, SetOptions(merge: true));

      await patientRef
          .collection('appointments')
          .doc(appointmentId)
          .set({
        'patientName': _name,
        'age': _age,
        'gender': _gender,
        'illness': _illness ?? '',
        'medications': _medications ?? '',
        'appointmentDate': _appointmentDate.toIso8601String(),
        'timeSlot': _timeSlot,
        'createdAt': Timestamp.now(),
        'email': email,
        'uid': uid,
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Appointment Saved"),
            content: const Text("Patient data has been successfully saved."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = "${_appointmentDate.toLocal()}".split(' ')[0];

    return Scaffold(
      appBar: AppBar(title: const Text("Patient Information")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Appointment on $formattedDate at $_timeSlot",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final age = int.tryParse(value);
                  if (age == null || age <= 0 || age > 120) return 'Enter a valid age';
                  return null;
                },
                onSaved: (value) => _age = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                validator: (value) => value == null ? 'Please select gender' : null,
                onChanged: (value) => _gender = value,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Illness / Complaint'),
                onSaved: (value) => _illness = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prescribed Medications'),
                onSaved: (value) => _medications = value,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Info"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
