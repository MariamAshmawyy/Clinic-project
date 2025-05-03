import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorSlotsScreen extends StatefulWidget {
  const DoctorSlotsScreen({super.key});

  @override
  DoctorSlotsScreenState createState() => DoctorSlotsScreenState();
}

class DoctorSlotsScreenState extends State<DoctorSlotsScreen> {
  Map<String, List<String>> weeklySlots = {};
  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'slots.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE slots(day TEXT, slot TEXT)');
      },
      version: 1,
    );
    _loadSlotsFromDB();
  }

  Future<void> _loadSlotsFromDB() async {
    final List<Map<String, dynamic>> maps = await _database.query('slots');
    Map<String, List<String>> loadedSlots = {};
    for (var map in maps) {
      loadedSlots.putIfAbsent(map['day'], () => []).add(map['slot']);
    }
    setState(() {
      weeklySlots = loadedSlots;
    });
  }

  Future<void> _addSlot(String dayKey, String slot) async {
    await _database.insert('slots', {'day': dayKey, 'slot': slot});
    setState(() {
      weeklySlots.putIfAbsent(dayKey, () => []).add(slot);
    });
  }

  Future<void> _removeSlot(String dayKey, String slot) async {
    await _database.delete('slots', where: 'day = ? AND slot = ?', whereArgs: [dayKey, slot]);
    setState(() {
      weeklySlots[dayKey]?.remove(slot);
    });
  }

  void _showAddSlotDialog(String dayKey) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Slot'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'e.g., 05:00 PM - 06:00 PM',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addSlot(dayKey, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _publishDayToFirebase(String dayKey) async {
    final firestore = FirebaseFirestore.instance;
    final slots = weeklySlots[dayKey] ?? [];
    await firestore.collection('doctor_slots').doc(dayKey).set({'slots': slots});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Slots for $dayKey published to Firebase')),
    );
  }

  static List<DateTime> getNext7Days() {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final next7Days = DoctorSlotsScreenState.getNext7Days();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Weekly Slots'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: next7Days.map((day) {
              final key = DateFormat('yyyy-MM-dd').format(day);
              final label = DateFormat('EEEE, MMM d').format(day);
              final slots = weeklySlots[key] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.cloud_upload, size: 20),
                        onPressed: () => _publishDayToFirebase(key),
                      )
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: slots.map((slot) {
                      return Chip(
                        label: Text(slot),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => _removeSlot(key, slot),
                      );
                    }).toList(),
                  ),
                  TextButton(
                    onPressed: () => _showAddSlotDialog(key),
                    child: const Text('+ Add Slot'),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
