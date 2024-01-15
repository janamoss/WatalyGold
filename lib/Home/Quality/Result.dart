import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Appbar_main_exit.dart';
import 'package:watalygold/Widgets/Color.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key,
      required this.ID_Result,
      required this.ID_Image,
      required this.capturedImage});

  final String ID_Result;
  final List<String> ID_Image;
  final List<File> capturedImage;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late String Grade;
  @override
  Widget build(BuildContext context) {
    CollectionReference results =
        FirebaseFirestore.instance.collection('Result');
    Future resultData = results.doc(widget.ID_Result).get();
    resultData.then((document) {
      Grade = document["Quality"];
    }).catchError((error) {
      // จัดการกับข้อผิดพลาด
    });
    return Scaffold(
      appBar: const AppbarMainExit(name: "วิเคราะห์คุณภาพ"),
      body: Column(
        children: [
          CarouselSlider(
            items: widget.capturedImage
                .map(
                  (image) => Image.file(
                    image,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 300,
            ),
          ),
          Card(
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(20),
              ),
              //set border radius more than 50% of height and width to make circle
            ),
            color: WhiteColor,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    color: Color(0xFF42BD41),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  width: double.infinity,
                  height: 35,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      "จากผลการวิเคราะห์คุณภาพพบว่า :",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25, top: 10),
                      child: Text(
                        "เกรดระดับ ",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8), fontSize: 20),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        "ขั้นพิเศษ",
                        style:
                            TextStyle(color: Color(0xFF42BD41), fontSize: 20),
                      ),
                    )
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        "มะม่วงมีขนาดและรูปร่างสวยงาม สีมะม่วงเหลืองทองสวย",
                        style:
                            TextStyle(color: Color(0xFF42BD41), fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Colors.white, Color(0xFFF2F6F5)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 8,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: Text(
                    "คุณต้องการที่จะบันทึกลงคอลเลคชั่นของคุณหรือไม่ ?",
                    style: TextStyle(fontSize: 17, color: Color(0xff069D73)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xff069D73), width: 2)),
                    onPressed: () {},
                    child: Text(
                      "บันทึกลงคอลเลคชั่นของคุณ",
                      style: TextStyle(color: Color(0xff069D73), fontSize: 15),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//           Container(
//             alignment: Alignment.topCenter,
//             // padding: const EdgeInsets.only(left: 25),
//             height: 130,
//             decoration: const BoxDecoration(
//               color: Colors.greenAccent,
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//             ),
//             child: const Text(
//               "จากผลการวิเคราะห์คุณภาพพบว่า :",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
