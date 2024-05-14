import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/models/Image.dart';

class ShareHistoryePage extends StatefulWidget {
  final String grade;
  final String anotherNote;
  final List<Images> images;

  const ShareHistoryePage(
      {required this.grade, required this.anotherNote, required this.images});

  @override
  _ShareHistoryePageState createState() => _ShareHistoryePageState();
}

class _ShareHistoryePageState extends State<ShareHistoryePage> {
  final _screenshotController = ScreenshotController();

  final Map<String, Color> gradeColor = {
    "ขั้นพิเศษ": Color(0xFF42BD41),
    "ขั้นที่ 1": Color(0xFF86BD41),
    "ขั้นที่ 2": Color(0xFFB6AC55),
    "ไม่เข้าข่าย": Color(0xFFB68955),
  };

  @override
  Widget build(BuildContext context) {
    // นำข้อมูลไปใช้ตามต้องการ
    return Scaffold(
      appBar: const AppbarMains(name: 'แชร์คลังความรู้'),
      backgroundColor: GreyColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(child: screenshot()),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                shareScreenshot();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GPrimaryColor,
              ),
              child: Text(
                'แชร์รูปภาพ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget screenshot() {
    return Screenshot(
      controller: _screenshotController,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CarouselSlider(
                  items: widget.images
                      .map(
                        (image) => Image.file(
                          File(image.image_url),
                          fit: BoxFit.cover,
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 300,
                  ),
                ),
              ),
            ),
            Container(
              width: 350,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/WatalyGoldIcons.png",
                    width: 90,
                    height: 90,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "เกรด",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.grade}",
                              style: TextStyle(
                                color: gradeColor["${widget.grade}"],
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 230,
                          child: Text(
                            "${widget.anotherNote}",style: TextStyle(
                                color: gradeColor["${widget.grade}"],
                               
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shareScreenshot() async {
    try {
      final imageUint8List = await _screenshotController.capture();
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/screenshot.png');
      await file.writeAsBytes(imageUint8List!);
      String text = "เกรด ${widget.grade} \n ${widget.anotherNote}";

      await Share.shareXFiles([XFile(file.path)], text: text);
    } catch (e) {
      print('Error sharing screenshot: $e');
      // Handle error
    }
  }
}
