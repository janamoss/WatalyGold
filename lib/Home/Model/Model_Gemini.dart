import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

/// ไม่ได้ใช้งานแล้ว Model ตัวนี้
class GeminiState extends ChangeNotifier {
  bool _isAnalyzing = false;
  String? _lastError;

  bool get isAnalyzing => _isAnalyzing;
  String? get lastError => _lastError;

  Future<String> analyzeMangoImage(File image) async {
    _isAnalyzing = true;
    _lastError = null;
    notifyListeners();

    try {
      final gemini = Gemini.instance;
      final result = await gemini.textAndImage(
        text: """ From the picture I gave you, can you check if there is a mango and a 5 baht coin in this picture? If there are both, then answer "mango". 
        If there are neither or if there is a hand or finger in the picture, then answer "not a mango". 
        Please note that this picture may show the mango from different angles, such as front, back, top or bottom. 
        The bottom may look like the top of the mango but there is no stem in the middle.""",
        images: [await image.readAsBytes()],
      );

      final geminiText = (result?.content?.parts?.last.text ?? '').trim();
      return geminiText;
    } catch (e) {
      _lastError = e.toString();
      debugPrint("Gemini Error: $_lastError");
      throw e;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }
}