import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_Error extends StatelessWidget {
  final String name;
  final String content;
  const Dialog_Error({super.key, required this.name, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: WhiteColor,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.only(bottom: 0, top: 20, right: 15, left: 15),
      actionsPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.red.shade400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: WhiteColor,
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: WhiteColor),
            ),
          ],
        ),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            )
          ],
        ),
      ),
      actions: [
        Center(
          child: Container(
            width: double.maxFinite,
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(2),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.red.shade400),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "เข้าใจแล้ว",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: WhiteColor),
                )),
          ),
        )
      ],
    );
  }
}