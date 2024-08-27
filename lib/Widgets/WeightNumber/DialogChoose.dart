import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_Choose extends StatefulWidget {
  const Dialog_Choose({super.key});

  @override
  State<Dialog_Choose> createState() => _Dialog_ChooseState();
}

class _Dialog_ChooseState extends State<Dialog_Choose> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "คุณต้องการกรอกน้ำหนัก\nมะม่วงแบบไหน ?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      surfaceTintColor: WhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Container(
        child: Column(
          children: [
            Text("",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15,color: Colors.grey.shade700),)
          ],
        ),
      ),
    );
  }
}
