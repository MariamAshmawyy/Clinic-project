import 'package:flutter/material.dart';

class DoctorAvailabilityScreen extends StatelessWidget {
  const DoctorAvailabilityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Chip(
              label: Text('Good Listener'),
              avatar: Icon(Icons.thumb_up),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.money, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('Fees: 350 EGP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Chip(
                  label: const Text('200 EGP with Shamel'),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 8),
                Text('Waiting Time: 21 min', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Nasr City: Elgehad Street\nBook and you will receive the address details', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Choose your appointment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAppointmentCard('Today', '2:30 PM', '10:30 PM', true),
                _buildAppointmentCard('Tomorrow', 'No Available', '', false),
                _buildAppointmentCard('Saturday 1/3', '4:30 PM', '11:59 PM', true),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Reservation required, first-come, first-served', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.card_giftcard, color: Colors.amber),
                SizedBox(width: 8),
                Text("You'll earn 350 points after booking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Follow-up is for Free within 10 Days', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 4),
                    Text('4.5/5 Clinic Rating', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 4),
                    Text('4.5/5 Assistant Rating', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(String day, String startTime, String endTime, bool available) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(day, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 8),
              available
                  ? Column(
                      children: [
                        Text(startTime, style: const TextStyle(fontSize: 14)),
                        const Text('To', style: TextStyle(fontSize: 14)),
                        Text(endTime, style: const TextStyle(fontSize: 14)),
                      ],
                    )
                  : Text(startTime, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: available ? Colors.red : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: available ? () {} : null,
                child: const Text('Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}