import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_Success extends StatefulWidget {
  final contents;
  const Dialog_Success({super.key, this.contents});

  @override
  State<Dialog_Success> createState() => _Dialog_SuccessState();
}

class _Dialog_SuccessState extends State<Dialog_Success> {
  bool _showWidget = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      // setState(() {
      //   _showWidget = false;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showWidget
        ? AlertDialog(
            backgroundColor: WhiteColor,
            title: Icon(
              Icons.verified_outlined,
              color: GPrimaryColor,
              size: 35,
            ),
            content: Text(
              widget.contents,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: GPrimaryColor,
              ),
            ),
            elevation: 2,
          )
        : Container();
  }
}

class Dialog_Success_collection extends StatefulWidget {
  final contents;
  const Dialog_Success_collection({super.key, this.contents});

  @override
  State<Dialog_Success_collection> createState() =>
      _Dialog_Success_collectionState();
}

class _Dialog_Success_collectionState extends State<Dialog_Success_collection> {
  bool _showWidget = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        _showWidget = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showWidget
        ? AlertDialog(
            backgroundColor: Colors.black,
            title: Icon(
              Icons.verified_outlined,
              color: WhiteColor,
              size: 35,
            ),
            content: Text(
              widget.contents,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: WhiteColor,
              ),
            ),
            elevation: 2,
          )
        : Container();
  }
}

void dialogsuccess(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // ป้องกันการปิด Dialog โดยการแตะพื้นหลัง
    builder: (BuildContext context) {
      return Dialog_Success(
        contents: "สร้างคอลเลคชั่นสำเร็จ",
      );
    },
  );

  // ตั้งเวลาให้ปิด Dialog หลังจาก 2 วินาที
  Timer(Duration(seconds: 2), () {
    Navigator.of(context).pop(); // ปิด Dialog
  });
}
