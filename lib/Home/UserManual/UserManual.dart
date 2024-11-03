import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/UserManual/Mangoproperties.dart';
import 'package:watalygold/Widgets/UserManual/Manualphoto.dart';
import 'package:watalygold/Widgets/UserManual/WeightManual.dart';

class UserManual extends StatefulWidget {
  const UserManual({Key? key}) : super(key: key);

  @override
  State<UserManual> createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GreyColor45,
      appBar: Appbarmain_no_botton(
        name: "คู่มือการใช้งาน",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ExpansionTile(
                collapsedShape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                collapsedBackgroundColor: GPrimaryColor,
                backgroundColor: GPrimaryColor,
                collapsedTextColor: Colors.black,
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Row(
                  children: [
                    SizedBox(width: 10),
                    Image.asset(
                      "assets/images/takeaphotos.png",
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    const Center(
                      child: SizedBox(
                        child: Text(
                          "วิธีถ่ายภาพมะม่วง",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                ),
                children: [
                  Manualphoto(),
                ],
              ),
              SizedBox(height: 10),
              ExpansionTile(
                collapsedShape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                collapsedBackgroundColor: GPrimaryColor,
                backgroundColor: GPrimaryColor,
                collapsedTextColor: Colors.black,
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 10),
                    Image.asset("assets/images/weightdigitalLogo.png",
                        width: 50, height: 50, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "วิธีถ่ายภาพหน้าจอเครื่องชั่งน้ำหนัก",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                children: [
                  WeightManual(),
                ],
                // children: [
                //   Expanded(
                //     child: Mangoproperties(),
                //   ),
                // ],
              ),
              SizedBox(height: 10),
              ExpansionTile(
                collapsedShape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                collapsedBackgroundColor: GPrimaryColor,
                backgroundColor: GPrimaryColor,
                collapsedTextColor: Colors.black,
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 10),
                    Image.asset(
                      "assets/images/mangoicon.png",
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "คุณสมบัติของมะม่วงแต่ละเกรด",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                children: [
                  Mangoproperties(),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
