import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../services/ble_service.dart';
import '../models/patient.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final db = DBService();
  final ble = BLEService();
  List<Patient> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    var docs = await db.fetchAllPatients();
    setState(() {
      _patients = docs.map((d) => Patient(
        id: d['id'],
        name: d['name'],
        age: d['age'],
        gender: d['gender'],
      )).toList();
    });
  }

  void _addOrEditPatient([Patient? patient]) {
    final _formKey = GlobalKey<FormState>();
    String name = patient?.name ?? '';
    int age = patient?.age ?? 0;
    String gender = patient?.gender ?? 'M';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(patient == null ? 'Add Patient' : 'Edit Patient'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (v) => name = v!,
              ),
              TextFormField(
                initialValue: age > 0 ? age.toString() : '',
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (v) => age = int.parse(v!),
              ),
              DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Male')),
                  DropdownMenuItem(value: 'F', child: Text('Female')),
                ],
                onChanged: (v) => gender = v!,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState!.save();
              if (patient == null) {
                await db.addPatient({'name': name, 'age': age, 'gender': gender});
              } else {
                await db.updatePatient(patient.id, {'name': name, 'age': age, 'gender': gender});
              }
              Navigator.pop(context);
              _loadPatients();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePatient(String id) async {
    await db.deletePatient(id);
    _loadPatients();
  }

  Future<void> _scanAndPair() async {
    await ble.scanAndConnect();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ECG Device Paired!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _scanAndPair,
              icon: const Icon(Icons.bluetooth),
              label: const Text('Scan & Pair ECG Sensor'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Patient Profiles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => _addOrEditPatient(),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _patients.length,
                itemBuilder: (context, i) {
                  final p = _patients[i];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.age} yrs, ${p.gender}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _addOrEditPatient(p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deletePatient(p.id),
                        ),
                      ],
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