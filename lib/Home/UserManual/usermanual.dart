import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/UserManual/Mangoproperties.dart';
import 'package:watalygold/Widgets/UserManual/Manualphoto.dart';

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
                          "วิธีถ่ายภาพมะม่วง ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 700,
                    child: const Manualphoto(),
                  ),
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
                  children: [
                    SizedBox(width: 10),
                    Image.asset(
                      "assets/images/mangoicon.png",
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    const Center(
                      child: SizedBox(
                        child: Text(
                          "คุณสมบัติของมะม่วงแต่ละเกรด ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                children: [
                  SizedBox(
                    height: 1600,
                    child: Mangoproperties(),
                  ),
                ],
                // children: [
                //   Expanded(
                //     child: Mangoproperties(),
                //   ),
                // ],
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}