import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialogwarningdel extends StatelessWidget {
  final String message;

  const Dialogwarningdel({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: WhiteColor,
      title: Column(
        children: [
          Icon(
            Icons.photo_camera_rounded,
            color: Colors.orange.shade300,
            size: 50,
          ),
          SizedBox(height: 10),
          Text(
            'คุณต้องการถ่ายรูปภาพใหม่ใช่หรือไม่',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade300),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "รูปภาพที่ต้องการถ่ายใหม่ : ",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              Text(
                "$message",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade400)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('ยกเลิก',
                    style: TextStyle(color: WhiteColor, fontSize: 16))),
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green.shade400)),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text('ตกลง',
                    style: TextStyle(color: WhiteColor, fontSize: 16))),
          ],
        ),
      ],
    );
  }
}
