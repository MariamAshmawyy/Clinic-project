import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/'); // Replace '/auth' with your auth screen route name
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  FadeInLeft(
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/doctor_image.jpg'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FadeInRight(
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr Tarek Ashmawy',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Consultant of otolaryngology and endoscopy, head, neck and skull base tumors - teacher of ENT, Faculty of Medicine, Ain Shams University',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    'Fees: 350 EGP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '200 EGP with Shamel',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Waiting Time: 21 min',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Location: Nasr City, Elgehad Street',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'You\'ll earn 350 points after booking',
                    style: TextStyle(fontSize: 14, color: Colors.orange),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Follow-up is for Free within 10 Days',
                    style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildGridItem(
                context,
                'Clinic Booking',
                Icons.local_hospital,
                '/appointment',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
