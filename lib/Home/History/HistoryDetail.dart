import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Home/History/ShareHistory.dart';
import 'package:watalygold/ShareResults.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Appbar_main_exit.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/models/Image.dart';
import 'package:watalygold/models/Result_ana.dart';

class HistoryDetail extends StatefulWidget {
  final Result results;
  final Map<int, List<Images>>? resultimage;

  const HistoryDetail({
    super.key,
    required this.results,
    this.resultimage,
  });
  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  List<double> listflaws_percent = [];
  List<double> listbrown_spot = [];

  double totalBrownSpot = 0;
  double totalFlawsPercent = 0;

  @override
  void initState() {
    super.initState();
    fetchImage(widget.results.result_id);
  }

  List<double> calculateFixedPercentages(List<double> n) {
    List<double> percentages = [40, 40, 20, 20];

    double total = n.reduce((a, b) => a + b); // คำนวณผลรวม

    List<double> results = [];
    for (int i = 0; i < n.length; i++) {
      if (i < percentages.length) {
        double result = (percentages[i] / 100) * total;
        results.add(result);
      } else {
        results.add(0); // กรณีที่ n มีความยาวมากกว่าจำนวนเปอร์เซ็นต์ที่กำหนด
      }
    }

    return results;
  }

  List<Images> _results = [];

  final ValueNotifier<List<Images>> _imageList = ValueNotifier([]);

  String checkMangoGrade(double weight) {
    if (weight >= 450) {
      return "ขั้นพิเศษ";
    } else if (weight > 350 && weight <= 449) {
      return "ขั้นที่ 1";
    } else if (weight > 250 && weight <= 349) {
      return "ขั้นที่ 2";
    } else {
      return "ไม่เข้าข่าย";
    }
  }

  String checkMangobrownSpots(double brownSpots) {
    if (brownSpots <= 10) {
      return "ขั้นพิเศษ";
    } else if (brownSpots <= 30) {
      return "ขั้นที่ 1";
    } else if (brownSpots <= 40) {
      return "ขั้นที่ 2";
    } else {
      return "ไม่เข้าข่าย";
    }
  }

  String checkMangoFlawsPercent(double maxBlemishes) {
    if (maxBlemishes <= 2) {
      return "ขั้นพิเศษ";
    } else if (maxBlemishes <= 4) {
      return "ขั้นที่ 1";
    } else if (maxBlemishes <= 5) {
      return "ขั้นที่ 2";
    } else {
      return "ไม่เข้าข่าย";
    }
  }

  Future<void> fetchImage(int result_id) async {
    _imageList.value = await Image_DB().fetchImageinResult(result_id);
    debugPrint("${_imageList.value.length}");

    // Populate listflaws_percent and listbrown_spot
    for (var image in _imageList.value) {
      listflaws_percent.add(image.flaws_percent);
      listbrown_spot.add(image.brown_spot);

      // Update totals

      // If we have 4 images, calculate fixed percentages
      if (listflaws_percent.length == 4 && listbrown_spot.length == 4) {
        List<double> fixedFlawsPercentages =
            calculateFixedPercentages(listflaws_percent);
        List<double> fixedBrownSpotPercentages =
            calculateFixedPercentages(listbrown_spot);

        totalFlawsPercent = fixedFlawsPercentages.reduce((a, b) => a + b);
        totalBrownSpot = fixedBrownSpotPercentages.reduce((a, b) => a + b);
        // You can use these fixed percentages as needed
        print("Fixed Flaws Percentages: $totalFlawsPercent");
        print("Fixed Brown Spot Percentages: $totalBrownSpot");
      }
    }

    setState(() {}); // Trigger a rebuild to reflect the changes
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, Color> gradeColor = {
      "ขั้นพิเศษ": Color(0xFF42BD41),
      "ขั้นที่ 1": Color(0xFF86BD41),
      "ขั้นที่ 2": Color(0xFFB6AC55),
      "ไม่เข้าข่าย": Color(0xFFB68955),
    };
    return ValueListenableBuilder(
      valueListenable: _imageList,
      builder: (context, images, child) {
        return Scaffold(
            appBar: const Appbarmain(name: "วิเคราะห์คุณภาพ"),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: images.isNotEmpty
                        ? CarouselSlider.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index, realIndex) {
                              final image = images[index];
                              return AspectRatio(
                                aspectRatio: 16 /
                                    9, // คุณสามารถปรับอัตราส่วนตามต้องการ เช่น 4/3, 1/1 เป็นต้น
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      File(image.image_url),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              aspectRatio:
                                  16 / 9, // ต้องตรงกับ AspectRatio ของ item
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          )
                        : Container(
                            child: Image.asset(
                              "assets/images/plain-grey-background-ydlwqztavi78gl24.jpg",
                              fit: BoxFit.cover,
                            ),
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
                            color: gradeColor[widget.results.quality],
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
                              padding: const EdgeInsets.only(left: 25, top: 10),
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
                                widget.results.quality,
                                style: TextStyle(
                                    color: gradeColor[widget.results.quality],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, top: 5, bottom: 10, right: 15),
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.results.another_note,
                                  style: TextStyle(
                                      color: gradeColor[widget.results.quality],
                                      fontSize: 17),
                                  // overflow: TextOverflow.ellipsis,
                                  // maxLines: 2,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
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
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.scale,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "น้ำหนัก : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                "${widget.results.weight.toStringAsFixed(2)} กรัม",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                            // Padding(
                            //   padding: EdgeInsets.only(left: 10, top: 17),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         widget.results.weight.toStringAsFixed(2) +
                            //             " กรัม",
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 18),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Text(
                            //         "เกรดระดับ : " +
                            //             checkMangoGrade(
                            //                 widget.results.weight.toDouble()),
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 16),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.brightness_1,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "พื้นที่จุดตำหนิ : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 10, top: 17),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "${averageFlawsPercent.toStringAsFixed(2)} ตารางเซนติเมตร",
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 18),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Text(
                            //         "เกรดระดับ : " +
                            //             checkMangoFlawsPercent(
                            //                 averageFlawsPercent.toDouble()),
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 16),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                "${totalFlawsPercent.toStringAsFixed(2)} ตารางเซนติเมตร",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.bubble_chart_rounded,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "พื้นที่จุดกระสีน้ำตาล : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 10, top: 17),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "${averageBrownSpot.toStringAsFixed(2)} เปอร์เซ็นต์",
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 18),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Text(
                            //         "เกรดระดับ : " +
                            //             checkMangobrownSpots(
                            //                 averageBrownSpot.toDouble()),
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 16),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                "${totalBrownSpot.toStringAsFixed(2)} เปอร์เซ็นต์",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          width: double.infinity,
                          height: 35,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Center(
                              child: Text(
                                "แบ่งปันผลการวิเคราะห์ให้กับเพื่อนของคุณ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 2, color: GPrimaryColor),
                                  backgroundColor: WhiteColor),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShareHistoryePage(
                                      grade: widget.results.quality,
                                      anotherNote: widget.results.another_note,
                                      images: _imageList.value,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.share,
                                    color: GPrimaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'แบ่งปันผลการวิเคราะห์ของคุณ',
                                    style: TextStyle(
                                      color: GPrimaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
