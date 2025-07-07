import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('ECG Monitor Help', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('1. To start monitoring, go to Home and tap the Bluetooth button.'),
            Text('2. To manage patients or pair a new device, go to Settings.'),
            Text('3. To export data, use the Export tab to generate a CSV file.'),
            Text('4. Alerts will appear in red at the bottom of the Home screen.'),
            Text('5. For further assistance, contact support@ecgmonitor.com.'),
          ],
        ),
      ),
    );
  }
}