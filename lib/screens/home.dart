import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/ble_service.dart';
import '../services/db_service.dart';
import '../services/ml_service.dart';
import '../widgets/ecg_chart.dart';
import '../widgets/alert_banner.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ble = BLEService();
  final db = DBService();
  final ml = MLService();

  List<FlSpot> ecgData = [];
  String currentAlert = 'Normal';
  StreamSubscription<double>? _sub;
  String patientId = 'demo_patient';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ml.loadModel();
  }

  void _toggleConnection() async {
    if (_sub == null) {
      await ble.scanAndConnect();
      _sub = ble.ecgStream().listen(_onData);
    } else {
      await ble.disconnect();
      await _sub?.cancel();
      _sub = null;
    }
    setState(() {});
  }

  void _onData(double value) async {
    setState(() {
      ecgData.add(FlSpot(ecgData.length.toDouble(), value));
      if (ecgData.length > 250) ecgData.removeAt(0);
    });

    if (ecgData.length == 250) {
      var window = ecgData.map((e) => e.y).toList();
      String res = await ml.predict(window);
      setState(() => currentAlert = res);

      await db.saveECGData(patientId, {
        'timestamp': DateTime.now().toIso8601String(),
        'value': window,
        'alert': res,
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ECG Monitor'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Add profile functionality
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: Column(
          children: [
            // Patient Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('John Doe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text('30 years | Male', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.teal[800],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ECG Chart
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ECGChart(data: ecgData),
              ),
            ),

            // Alert Banner
            Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: AlertBanner(message: currentAlert),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.upload_outlined), label: 'Export'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
            BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
          ],
          onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0: context.go('/home');    break;
            case 1: context.go('/export');  break;
            case 2: context.go('/settings');break;
            case 3: context.go('/help');    break;
          }
        },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleConnection,
        backgroundColor: _sub == null ? Colors.teal : Colors.red,
        child: Icon(
          _sub == null ? Icons.bluetooth : Icons.bluetooth_disabled,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}