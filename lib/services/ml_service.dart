import 'dart:typed_data';
import 'package:tflite/tflite.dart';

class MLService {
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/ecg_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<String> predict(List<double> window) async {
    var byteData = ByteData(window.length * 4);
    for (int i = 0; i < window.length; i++) {
      byteData.setFloat32(i * 4, window[i] / 1000.0, Endian.little);
    }
    var res = await Tflite.runModelOnBinary(
      binary: byteData.buffer.asUint8List(),
      numResults: 1,
    );
    return res?.first['label'] ?? 'Unknown';
  }
}