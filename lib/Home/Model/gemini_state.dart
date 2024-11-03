import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProcessCountProvider with ChangeNotifier {
  bool _isLimitReached = false;
  bool get isLimitReached => _isLimitReached;

  Future<void> checkProcessCount() async {
/*************  ✨ Codeium Command ⭐  *************/
  /// ตรวจสอบจำนวนครั้งการประมวลผล Gemini ในวันที่ปัจจุบัน
  /// ถ้าจำนวนครั้งการประมวลผลมากกว่าหรือเท่ากับ 1500 จะเปลี่ยน state เป็น true
  /// ถ้าไม่พบข้อมูลจะเปลี่ยน state เป็น false
/******  58c6e34b-5478-4ccb-b865-317f7fa0b74b  *******/    try {
      // รับวันที่ปัจจุบันในรูปแบบ yyyy-MM-dd
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // ดึงข้อมูลจาก Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('GeminiProcesscount')
          .doc(today)
          .get();

      if (doc.exists) {
        // ดึงค่า process_count
        int processCount = doc.get('process_count') as int;
        _isLimitReached = processCount >= 1500;
        notifyListeners();
      } else {
        _isLimitReached = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error checking process count: $e');
      _isLimitReached = false;
      notifyListeners();
    }
  }
}