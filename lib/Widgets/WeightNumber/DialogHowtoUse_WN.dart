import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_HowtoUse_NW extends StatefulWidget {
  const Dialog_HowtoUse_NW({super.key});

  @override
  State<Dialog_HowtoUse_NW> createState() => _Dialog_HowtoUse_NWState();
}

class _Dialog_HowtoUse_NWState extends State<Dialog_HowtoUse_NW> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      contentPadding: EdgeInsets.all(20),
      surfaceTintColor: WhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "ภาพถ่ายน้ำหนักมะม่วงจากตาชั่งดิจิทัล",
              style: TextStyle(
                fontSize: 15,
              ),
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
                    "assets/images/WeightNumber/WeightNumber.png",
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "1.ห้ามถ่ายใกล้หรือไกลเกิน",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/images/WeightNumber/closefar.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "2.พื้นที่มีแสงเพียงพอ",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/images/WeightNumber/Whiteblack.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("checkhowtouse_nw", true);
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
        "คู่มือการถ่ายภาพ",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: GPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: WhiteColor,
      elevation: 2,
    );
  }
}
