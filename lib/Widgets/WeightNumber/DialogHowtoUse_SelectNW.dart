import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_Howtouse_SelectNW extends StatelessWidget {
  const Dialog_Howtouse_SelectNW({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      contentPadding: EdgeInsets.all(20),
      surfaceTintColor: WhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "เลือกภาพถ่ายจากตาชั่งดิจิทัล ที่เห็นตัวเลขและหน่วยของตาชั่งดิจิทัลอย่างชัดเจน",
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(5),
              // decoration: BoxDecoration(
              //     border: Border.all(
              //       color: GPrimaryColor.withOpacity(0.5),
              //       width: 2,
              //     ),
              //     borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/WeightNumber/WeightNumber_Cut.png",
                    width: 200,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "คำแนะนำ",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.crop_free_rounded,
                size: 25,
                color: GPrimaryColor,
              ),
              title: Text(
                "ครอบภาพให้คล้ายคลึงกับตัวอย่างให้ใกล้เคียงมากที่สุด",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.camera_enhance_rounded,
                size: 25,
                color: GPrimaryColor,
              ),
              title: Text(
                "เป็นภาพถ่ายที่เห็นตัวเลขจากตาชั่งและหน่วยอย่างชัดเจน",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(GPrimaryColor),
                    elevation: MaterialStatePropertyAll(1)),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text('เข้าใจแล้ว',
                    style: TextStyle(
                      color: WhiteColor,
                      fontSize: 16,
                    ))),
          ),
        )
      ],
      title: Text(
        "คู่มือการเลือกภาพถ่าย",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: GPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: WhiteColor,
      elevation: 2,
    );
  }
}
