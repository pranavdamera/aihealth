import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import '../services/db_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});
  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final db = DBService();
  bool _loading = false;
  String? _filePath;
  String patientId = 'demo_patient';

  Future<void> _exportCSV() async {
    setState(() => _loading = true);
    // Fetch records
    var records = await db.fetchECGData(patientId);

    // Prepare CSV rows
    List<List<dynamic>> rows = [];
    rows.add(['timestamp', 'ecg_values', 'alert']);
    for (var rec in records) {
      rows.add([
        rec['timestamp'],
        rec['value'].join(';'),
        rec['alert'],
      ]);
    }

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(rows);

    // Save to file
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/ecg_export.csv';
    final file = File(path);
    await file.writeAsString(csv);

    setState(() {
      _filePath = path;
      _loading = false;
    });

    // Share
    Share.shareFiles([path], text: 'ECG Data Export');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _exportCSV,
                icon: const Icon(Icons.file_download),
                label: const Text('Export to CSV & Share'),
              ),
      ),
    );
  }
}