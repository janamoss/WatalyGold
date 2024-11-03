import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class ModelState extends ChangeNotifier {
  tfl.Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoading = true;

  tfl.Interpreter? get interpreter => _interpreter;
  List<String> get labels => _labels;
  bool get isLoading => _isLoading;

  Future<void> initializeModel(BuildContext context) async {
    try {
      // โหลดโมเดล
      _interpreter = await tfl.Interpreter.fromAsset("assets/mango_color.tflite");
      
      // โหลด labels
      final labelsData = await DefaultAssetBundle.of(context).loadString('assets/lebels.txt');
      _labels = labelsData.split('\n');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing model: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<double> runModelInference(File image) async {
    if (_interpreter == null) {
      throw Exception('Interpreter is not initialized');
    }

    try {
      // แปลงภาพและเตรียมข้อมูล input
      Uint8List inputBytes = preProcessingImage(image);
      var input = inputBytes.buffer.asFloat32List().reshape([1, 64, 64, 3]);
      
      // สำหรับ output แบบ sigmoid
      var outputBuffer = List<double>.filled(1, 0).reshape([1, 1]);
      
      // รันโมเดล
      _interpreter!.run(input, outputBuffer);
      
      return outputBuffer[0][0];
    } catch (e) {
      debugPrint('Error in model inference: $e');
      rethrow;
    }
  }

  Uint8List preProcessingImage(File capturedImages) {
    // อ่านภาพและ resize ให้เป็น 64x64
    img.Image? image = img.decodeImage(capturedImages.readAsBytesSync());
    img.Image? resizedImage = img.copyResize(image!, width: 64, height: 64);

    // แปลงเป็น Uint8List (พิกเซลในรูปแบบตัวเลข)
    Uint8List bytes = resizedImage.getBytes();

    // สร้าง Float32List สำหรับการ normalize ค่าพิกเซล
    Float32List normalizedBytes = Float32List(bytes.length);
    for (int i = 0; i < bytes.length; i++) {
      normalizedBytes[i] = bytes[i] / 255.0;
    }

    return normalizedBytes.buffer.asUint8List();
  }


  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}
