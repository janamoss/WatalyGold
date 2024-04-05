import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  bool _loading = true;

  late String grade = ''; // Initialize grade with a default value
  late String anotherNote = '';
  late double weight = 0.0;
  late double length = 0.0;
  late double width = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
    });
    try {
      final results = FirebaseFirestore.instance.collection('Result');
      final document = await results.doc(widget.ID_Result).get();
      grade = document['Quality'];
      weight = document['Weight'];
      length = document['Length'];
      width = document['Width'];
      anotherNote = document['Another_note'];
      setState(() {
        _loading = false;
      }); // อัพเดตการแสดงผล
    } catch (error) {
      // จัดการข้อผิดพลาด
    }
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, Color> gradeColor = {
      "ขั้นพิเศษ": Color(0xFF42BD41),
      "ขั้นที่ 1": Color(0xFF86BD41),
      "ขั้นที่ 2": Color(0xFFB6AC55),
      "ไม่เข้าข่าย": Color(0xFFB68955),
    };
    return Scaffold(
        appBar: const AppbarMainExit(name: "วิเคราะห์คุณภาพ"),
        body: SingleChildScrollView(
          child: _loading
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: WhiteColor,
                    secondRingColor: GPrimaryColor,
                    thirdRingColor: YPrimaryColor,
                    size: 200,
                  ),
                )
              : Column(
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
                            decoration: BoxDecoration(
                              color: gradeColor[grade],
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20)),
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
                                padding:
                                    const EdgeInsets.only(left: 25, top: 10),
                                child: Text(
                                  "เกรดระดับ ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  "$grade",
                                  style: TextStyle(
                                      color: gradeColor[grade], fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25, top: 5, bottom: 10, right: 15),
                                child: Text(
                                  anotherNote,
                                  style: TextStyle(
                                      color: gradeColor[grade], fontSize: 15),
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
                      margin: const EdgeInsets.all(25),
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Colors.white, Color(0xFFF2F6F5)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadows: const [
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
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 25, left: 25, right: 25),
                            child: Text(
                              "คุณต้องการที่จะบันทึกลงคอลเลคชั่นของคุณหรือไม่ ?",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff069D73)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xff069D73), width: 2)),
                              onPressed: () {},
                              child: const Text(
                                "บันทึกลงคอลเลคชั่นของคุณ",
                                style: TextStyle(
                                    color: Color(0xff069D73), fontSize: 15),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(10),
                        ),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      color: WhiteColor,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                              color: Color(0xFF069D73),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            width: double.infinity,
                            height: 35,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "รายละเอียด",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, top: 15, bottom: 8),
                                child: Text(
                                  "น้ำหนัก : ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 17),
                                child: Text(
                                  weight.toStringAsFixed(2) + " กรัม",
                                  style: TextStyle(
                                      color: Color(0xFF42BD41), fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, top: 15, bottom: 8),
                                child: Text(
                                  "ความยาว : ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 17),
                                child: Text(
                                  length.toStringAsFixed(2) + " เซนติเมตร",
                                  style: TextStyle(
                                      color: Color(0xFF42BD41), fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, top: 15, bottom: 8),
                                child: Text(
                                  "ความกว้าง : ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 17),
                                child: Text(
                                  width.toStringAsFixed(2) + " เซนติเมตร",
                                  style: TextStyle(
                                      color: Color(0xFF42BD41), fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
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
