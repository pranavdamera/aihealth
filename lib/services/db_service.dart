import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveECGData(String patientId, Map<String, dynamic> entry) async {
    await _db
        .collection('patients')
        .doc(patientId)
        .collection('ecg_records')
        .add(entry);
  }

  Future<List<Map<String, dynamic>>> fetchECGData(String patientId) async {
    var snap = await _db
        .collection('patients')
        .doc(patientId)
        .collection('ecg_records')
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchAllPatients() async {
    // Implementation depends on your database (Firestore/SQLite/etc.)
    // Example for Firestore:
    final snapshot = await FirebaseFirestore.instance.collection('patients').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // CRUD patient profiles
  Future<void> addPatient(Map<String, dynamic> data) async {
    await _db.collection('patients').add(data);
  }
  Future<void> updatePatient(String id, Map<String, dynamic> data) async {
    await _db.collection('patients').doc(id).update(data);
  }
  Future<void> deletePatient(String id) async {
    await _db.collection('patients').doc(id).delete();
  }
}