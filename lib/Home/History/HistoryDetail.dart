import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    fetchImage(widget.results.result_id);
  }

  List<Images> _results = [];

  final ValueNotifier<List<Images>> _imageList = ValueNotifier([]);
  Future<void> fetchImage(int result_id) async {
    _imageList.value = await Image_DB().fetchImageinResult(result_id);
    stdout.writeln(_imageList.value.length);
    return;
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
        appBar: const Appbarmain(name: "วิเคราะห์คุณภาพ"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _imageList,
                builder: (context, images, child) {
                  return Card(
                    child: images.isNotEmpty
                        ? CarouselSlider.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index, realIndex) {
                              final image = images[index];
                              return Container(
                                child: Image.file(
                                  File(image.image_url),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 300,
                            ),
                          )
                        : Container(
                            child: Image.asset(
                              "assets/images/plain-grey-background-ydlwqztavi78gl24.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                  );
                },
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
                          child: Text(
                            widget.results.another_note,
                            style: TextStyle(
                                color: gradeColor[widget.results.quality],
                                fontSize: 15),
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
                            widget.results.weight.toStringAsFixed(2) + " กรัม",
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
                            widget.results.length.toStringAsFixed(2) +
                                " เซนติเมตร",
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
                            widget.results.width.toStringAsFixed(2) +
                                " เซนติเมตร",
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
                              side: BorderSide(width: 2, color: GPrimaryColor),
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
  }
}
