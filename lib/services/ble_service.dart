import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  BluetoothDevice? _device;
  Stream<List<int>>? _ecgStream;

  Future<void> scanAndConnect() async {
  StreamSubscription<List<ScanResult>>? subscription;

  // Start scanning
  await FlutterBluePlus.startScan();

  // Assign the subscription after declaration
  subscription = FlutterBluePlus.scanResults.listen((results) async {
    for (ScanResult result in results) {
      if (result.device.name.contains('ECG')) {
        _device = result.device;
        await FlutterBluePlus.stopScan();
        await _device!.connect();
        await subscription?.cancel(); // Now safe to call
        break;
      }
    }
  });

  // Optional: Stop scan if no device is found within 5 seconds
  await Future.delayed(Duration(seconds: 5));
  await FlutterBluePlus.stopScan();
}


  Future<void> disconnect() async {
    await _device?.disconnect();
  }

  Stream<double> ecgStream() {
    if (_ecgStream != null) {
      return _ecgStream!.map(_bytesToValue);
    }

    // Discover and subscribe to ECG characteristic
    return Stream.fromFuture(_device!.discoverServices())
        .asyncExpand((services) => Stream.fromIterable(services))
        .where((s) => s.uuid.toString().toLowerCase().contains('ecg'))
        .asyncExpand((s) => Stream.fromIterable(s.characteristics))
        .where((c) => c.properties.notify)
        .asyncExpand((c) {
          // Set notify to true before subscribing to value stream
          c.setNotifyValue(true);
          return c.onValueReceived;
        })
        .map(_bytesToValue);
  }

  double _bytesToValue(List<int> bytes) {
    return bytes.isNotEmpty ? bytes.first.toDouble() : 0.0;
  }
}
