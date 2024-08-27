import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold/Widgets/Color.dart';

final List<Map<String, String>> mangoImages = [
  {"image": "assets/images/f5.jpg", "label": "ด้านหน้า"},
  {"image": "assets/images/back5.jpg", "label": "ด้านหลัง"},
  {"image": "assets/images/Bottom5.jpg", "label": "ด้านล่าง"},
  {"image": "assets/images/top5.jpg", "label": "ด้านบน"},
];

class Dialog_HowtoUse extends StatefulWidget {
  const Dialog_HowtoUse({super.key});

  @override
  State<Dialog_HowtoUse> createState() => _Dialog_HowtoUseState();
}

class _Dialog_HowtoUseState extends State<Dialog_HowtoUse> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

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
              "ภาพถ่ายมะม่วงทั้ง 4 ด้าน",
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
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: 165,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: mangoImages.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  item['image']!,
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  item['label']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: mangoImages.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: GPrimaryColor.withOpacity(
                                _current == entry.key ? 0.9 : 0.4),
                          ),
                        ),
                      );
                    }).toList(),
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
                        "1.พื้นหลังเป็นสีขาวล้วน",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/images/HowtoUse/WhiteBackground.jpg",
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
                        "2.มีเหรียญ 5 บาทในภาพ",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/images/HowtoUse/Coin5.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
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
                        "3.ห้ามถ่ายใกล้หรือไกลเกิน",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/images/HowtoUse/CloseFar.jpg",
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
                        "4.พื้นที่มีแสงเพียงพอ",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/images/HowtoUse/LightDark.jpg",
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
                  prefs.setBool("checkhowtouse", true);
                  Navigator.of(context).pop();
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
