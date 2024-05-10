import 'package:flutter/material.dart';
import 'package:watalyGold/widget/Color.dart';
import 'package:watalyGold/widget/Mangoproperties.dart';
import 'package:watalyGold/widget/Manualphoto.dart';



class UserManual extends StatefulWidget {
  const UserManual({Key? key}) : super(key: key);

  @override
  State<UserManual> createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        title: const Text(
          "คู่มือการใช้งาน",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: GPrimaryColor,
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
                backgroundColor:
                    GPrimaryColor, // สีพื้นหลังเมื่อ ExpansionTile ถูกปิด
                collapsedTextColor:
                    Colors.black, // สีข้อความเมื่อ ExpansionTile ถูกปิด
                textColor:
                    Colors.white, // สีข้อความเมื่อ ExpansionTile ถูกเปิด
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
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 500,
                    child: Manualphoto(),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              ExpansionTile(
                collapsedShape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                collapsedBackgroundColor: GPrimaryColor,
                backgroundColor:
                    GPrimaryColor, // สีพื้นหลังเมื่อ ExpansionTile ถูกปิด
                collapsedTextColor:
                    Colors.black, // สีข้อความเมื่อ ExpansionTile ถูกปิด
                textColor:
                    Colors.white, // สีข้อความเมื่อ ExpansionTile ถูกเปิด
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
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 1300,
                    child: Mangoproperties(),
                  ),
                  
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}
