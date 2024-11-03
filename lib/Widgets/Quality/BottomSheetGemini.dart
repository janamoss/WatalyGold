import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class BottomSheetGemini extends StatelessWidget {
  const BottomSheetGemini({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sync_problem_rounded,
            size: 80,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            "การวิเคราะห์คุณภาพต่อจากนี้จะไม่มีการตรวจสอบบางขั้นตอน",
            style: TextStyle(
              fontSize: 18,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red.shade300),
            ),
            child: const Text(
              "เข้าใจแล้ว",
              style: TextStyle(color: WhiteColor, fontSize: 15),
            ),
          ),
        ]);
  }
}
