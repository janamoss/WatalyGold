import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_Update_Collection extends StatefulWidget {
  final contents;
  const Dialog_Update_Collection({super.key, this.contents});

  @override
  State<Dialog_Update_Collection> createState() =>
      _Dialog_Update_CollectionState();
}

class _Dialog_Update_CollectionState extends State<Dialog_Update_Collection> {
  bool _showWidget = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _showWidget
        ? AlertDialog(
            backgroundColor: Colors.white,
            title: Icon(
              Icons.update_outlined,
              color: yellowColor,
              size: 35,
            ),
            content: Text(
              widget.contents,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: yellowColor,
              ),
            ),
            elevation: 2,
          )
        : Container();
  }
}

void dialogupdate(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // ป้องกันการปิด Dialog โดยการแตะพื้นหลัง
    builder: (BuildContext context) {
      return Dialog_Update_Collection(
        contents: "อัพเดทคอลเลคชันเสร็จสิ้น",
      );
    },
  );

  // ตั้งเวลาให้ปิด Dialog หลังจาก 2 วินาที
  Timer(Duration(seconds: 2), () {
    Navigator.of(context).pop(); // ปิด Dialog
  });
}
