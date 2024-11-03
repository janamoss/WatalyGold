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
  int _currentPage = 0; // เก็บค่าหน้าปัจจุบัน
  PageController _controllers = PageController();

  @override
  void initState() {
    super.initState();

    // ตั้งค่า PageController เพื่อเช็คการเปลี่ยนหน้า
    _controllers.addListener(() {
      setState(() {
        // อัปเดตหน้าปัจจุบันที่แสดงอยู่
        _currentPage = _controllers.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      contentPadding: EdgeInsets.all(20),
      surfaceTintColor: WhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Container(
        width: double.maxFinite,
        height: 400, // ตั้งค่าให้สูงพอสำหรับสองหน้า
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300), // ระยะเวลาแอนิเมชัน
                  curve: Curves.easeInOut, // ลักษณะแอนิเมชันให้ smooth
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentPage == index ? 12.0 : 8.0, // ขนาดของวงกลม
                  height: _currentPage == index ? 12.0 : 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.green : Colors.grey,
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PageView(controller: _controllers, children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "ภาพถ่ายมะม่วงทั้ง 4 ด้าน",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
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
                                  height: 215,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              item['image']!,
                                              fit: BoxFit.cover,
                                              height: 150,
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
                                children:
                                    mangoImages.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _controller.animateToPage(entry.key),
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
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
                ),
                // หน้าที่ 2
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "ลักษณะของผลลัพธ์การวิเคราะห์",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 150,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: GPrimaryColor,
                                          width: 5,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Image.asset(
                                        "assets/images/f5.jpg",
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white,
                                        ),
                                        Icon(
                                          Icons.check,
                                          size: 40,
                                          weight: 10,
                                          color: GPrimaryColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width:
                                        10), // เพิ่มระยะห่างระหว่างรูปภาพกับข้อความ
                                Expanded(
                                  // เพื่อให้ข้อความไม่ล้นขอบ
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit
                                              .scaleDown, // ย่อขนาดให้พอดีกับขอบเขต
                                          child: Text(
                                            '1. ผลวิเคราะห์ถูกต้อง',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: GPrimaryColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "วัตถุที่ถ่ายเป็นมะม่วงและมะม่วงเป็นสีเหลืองทอง และมีเหรียญ 5 บาท",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 150,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.red.shade400,
                                          width: 5,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Image.asset(
                                        "assets/images/f5.jpg",
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white,
                                        ),
                                        Icon(
                                          Icons.close,
                                          size: 40,
                                          weight: 10,
                                          color: Colors.red.shade400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width:
                                        10), // เพิ่มระยะห่างระหว่างรูปภาพกับข้อความ
                                Expanded(
                                  // เพื่อให้ข้อความไม่ล้นขอบ
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit
                                              .scaleDown, // ย่อขนาดให้พอดีกับขอบเขต
                                          child: Text(
                                            '2. ผลวิเคราะห์ไม่ถูกต้อง',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.red.shade400,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "วัตถุที่ถ่ายไม่ได้เป็นมะม่วงหรือมะม่วงไม่เป็นสีเหลืองทอง และไม่มีเหรียญ 5 บาท ต้องทำการถ่ายภาพใหม่อีกครั้ง",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ListTile(
                        //   leading: Icon(
                        //     Icons.crop_free_rounded,
                        //     size: 25,
                        //     color: GPrimaryColor,
                        //   ),
                        //   title: Text(
                        //     "ครอบภาพให้คล้ายคลึงกับตัวอย่างให้ใกล้เคียงมากที่สุด",
                        //     style: TextStyle(
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        // ),
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.camera_enhance_rounded,
                        //     size: 25,
                        //     color: GPrimaryColor,
                        //   ),
                        //   title: Text(
                        //     "เป็นภาพถ่ายที่เห็นตัวเลขจากตาชั่งและหน่วยอย่างชัดเจน",
                        //     style: TextStyle(
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ]),
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
