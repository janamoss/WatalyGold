import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogHowtoUse.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogAlertWNbyGemini.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogHowtoUse_WN.dart';

final List<Map<String, String>> mangoImages = [
  {"image": "assets/images/f5.jpg", "label": "ด้านหน้า"},
  {"image": "assets/images/back5.jpg", "label": "ด้านหลัง"},
  {"image": "assets/images/Bottom5.jpg", "label": "ด้านล่าง"},
  {"image": "assets/images/top5.jpg", "label": "ด้านบน"},
];

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  PageController _controllerpage = PageController();
  int _currentPage = 0;

  Future<void> analyzeImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      final gemini = Gemini.instance;
      final result = await gemini.textAndImage(
        text:
            """The picture that you checked, please help me identify whether this is a mango or not. 
            If it is a mango, answer "mango". If it is not a mango, answer "not mango".""",
        images: [file.readAsBytesSync()],
      );

      final geminiText = result?.content?.parts?.last.text ?? '';
      debugPrint("Gemini response: $geminiText");
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerpage.addListener(() {
      setState(() {
        _currentPage = _controllerpage.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // showDialog(
                //   context: context,
                //   barrierDismissible: false,
                //   builder: (context) => Center(
                //     child: AlertDialog(
                //       backgroundColor: GPrimaryColor.withOpacity(0.6),
                //       contentPadding: const EdgeInsets.symmetric(
                //           vertical: 10, horizontal: 10),
                //       title: Column(
                //         children: [
                //           FittedBox(
                //             fit: BoxFit.scaleDown,
                //             child: Text(
                //               'กำลังตรวจสอบน้ำหนัก . . .',
                //               style: TextStyle(color: WhiteColor, fontSize: 20),
                //               textAlign: TextAlign
                //                   .center, // Add this line to center the title text
                //             ),
                //           ),
                //           const SizedBox(
                //             height: 15,
                //           ),
                //           LoadingAnimationWidget.discreteCircle(
                //             color: WhiteColor,
                //             secondRingColor: GPrimaryColor,
                //             thirdRingColor: YPrimaryColor,
                //             size: 70,
                //           ),
                //         ],
                //       ),
                //       // actions: [],
                //     ),
                //   ),
                // );

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => PopScope(
                    canPop: false,
                    child: Center(
                      child: AlertDialog(
                        backgroundColor: GPrimaryColor.withOpacity(0.6),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        title: Column(
                          children: [
                            const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'กำลังวิเคราะห์คุณภาพ',
                                style:
                                    TextStyle(color: WhiteColor, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            LoadingAnimationWidget.discreteCircle(
                              color: WhiteColor,
                              secondRingColor: GPrimaryColor,
                              thirdRingColor: YPrimaryColor,
                              size: 70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

                await Future.delayed(Duration(seconds: 3));

                Navigator.of(context).pop();

                // showDialog(
                //   barrierDismissible: false,
                //   context: context,
                //   builder: (context) {
                //     return Dialog_HowtoUse_NW();
                //   },
                // );
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       insetPadding: EdgeInsets.all(15),
                //       contentPadding: EdgeInsets.all(20),
                //       surfaceTintColor: WhiteColor,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(10))),
                //       title: Text(
                //         "คู่มือการถ่ายภาพ",
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             color: GPrimaryColor,
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold),
                //       ),
                //       backgroundColor: WhiteColor,
                //       elevation: 2,
                //       content: Container(
                //         width: double.maxFinite,
                //         height: 500, // ตั้งค่าให้สูงพอสำหรับสองหน้า
                //         child: Column(
                //           children: [
                //             Expanded(
                //               child: PageView(
                //                 children: [
                //                   // หน้าแรก
                //                   Container(
                //                     height: MediaQuery.of(context).size.height *
                //                         0.6,
                //                     width: MediaQuery.of(context).size.width,
                //                     child: SingleChildScrollView(
                //                       child: Column(
                //                         children: [
                //                           Text(
                //                             "ภาพถ่ายมะม่วงทั้ง 4 ด้าน",
                //                             style: TextStyle(
                //                               fontSize: 15,
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             height: 5,
                //                           ),
                //                           Container(
                //                             padding: EdgeInsets.all(5),
                //                             // decoration: BoxDecoration(
                //                             //     border: Border.all(
                //                             //       color: GPrimaryColor.withOpacity(0.5),
                //                             //       width: 2,
                //                             //     ),
                //                             //     borderRadius: BorderRadius.all(Radius.circular(5))),
                //                             child: Column(
                //                               children: [
                //                                 CarouselSlider(
                //                                   carouselController:
                //                                       _controller,
                //                                   options: CarouselOptions(
                //                                     height: 215,
                //                                     enlargeCenterPage: true,
                //                                     aspectRatio: 16 / 9,
                //                                     autoPlayCurve:
                //                                         Curves.fastOutSlowIn,
                //                                     enableInfiniteScroll: true,
                //                                     viewportFraction: 1,
                //                                     onPageChanged:
                //                                         (index, reason) {
                //                                       setState(() {
                //                                         _current = index;
                //                                       });
                //                                     },
                //                                   ),
                //                                   items:
                //                                       mangoImages.map((item) {
                //                                     return Builder(
                //                                       builder: (BuildContext
                //                                           context) {
                //                                         return Container(
                //                                           width: MediaQuery.of(
                //                                                   context)
                //                                               .size
                //                                               .width,
                //                                           decoration:
                //                                               BoxDecoration(
                //                                             color: Colors
                //                                                 .transparent,
                //                                           ),
                //                                           child: Column(
                //                                             mainAxisAlignment:
                //                                                 MainAxisAlignment
                //                                                     .center,
                //                                             children: [
                //                                               Image.asset(
                //                                                 item['image']!,
                //                                                 fit: BoxFit
                //                                                     .cover,
                //                                                 height: 150,
                //                                               ),
                //                                               SizedBox(
                //                                                   height: 10),
                //                                               Text(
                //                                                 item['label']!,
                //                                                 style:
                //                                                     TextStyle(
                //                                                   fontSize: 16,
                //                                                   color: Colors
                //                                                       .black,
                //                                                 ),
                //                                               ),
                //                                             ],
                //                                           ),
                //                                         );
                //                                       },
                //                                     );
                //                                   }).toList(),
                //                                 ),
                //                                 Row(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                   children: mangoImages
                //                                       .asMap()
                //                                       .entries
                //                                       .map((entry) {
                //                                     return GestureDetector(
                //                                       onTap: () => _controller
                //                                           .animateToPage(
                //                                               entry.key),
                //                                       child: Container(
                //                                         width: 8.0,
                //                                         height: 8.0,
                //                                         margin: EdgeInsets
                //                                             .symmetric(
                //                                                 vertical: 4.0,
                //                                                 horizontal:
                //                                                     4.0),
                //                                         decoration:
                //                                             BoxDecoration(
                //                                           shape:
                //                                               BoxShape.circle,
                //                                           color: GPrimaryColor
                //                                               .withOpacity(
                //                                                   _current ==
                //                                                           entry
                //                                                               .key
                //                                                       ? 0.9
                //                                                       : 0.4),
                //                                         ),
                //                                       ),
                //                                     );
                //                                   }).toList(),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             height: 10,
                //                           ),
                //                           Text(
                //                             "คำแนะนำ",
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 fontSize: 15),
                //                           ),
                //                           SizedBox(
                //                             height: 10,
                //                           ),
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Container(
                //                                 width: 150,
                //                                 child: Column(
                //                                   children: [
                //                                     Text(
                //                                       textAlign:
                //                                           TextAlign.center,
                //                                       "1.พื้นหลังเป็นสีขาวล้วน",
                //                                       style: TextStyle(
                //                                           fontSize: 13),
                //                                     ),
                //                                     SizedBox(
                //                                       height: 10,
                //                                     ),
                //                                     Container(
                //                                       width: 100,
                //                                       height: 100,
                //                                       child: Image.asset(
                //                                         "assets/images/HowtoUse/WhiteBackground.jpg",
                //                                         fit: BoxFit.cover,
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                               Container(
                //                                 width: 150,
                //                                 child: Column(
                //                                   children: [
                //                                     Text(
                //                                       textAlign:
                //                                           TextAlign.center,
                //                                       "2.มีเหรียญ 5 บาทในภาพ",
                //                                       style: TextStyle(
                //                                           fontSize: 13),
                //                                     ),
                //                                     SizedBox(
                //                                       height: 10,
                //                                     ),
                //                                     Container(
                //                                       width: 100,
                //                                       height: 100,
                //                                       child: Image.asset(
                //                                         "assets/images/HowtoUse/Coin5.jpg",
                //                                         fit: BoxFit.cover,
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                           SizedBox(
                //                             height: 15,
                //                           ),
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Container(
                //                                 width: 150,
                //                                 child: Column(
                //                                   children: [
                //                                     Text(
                //                                       textAlign:
                //                                           TextAlign.center,
                //                                       "3.ห้ามถ่ายใกล้หรือไกลเกิน",
                //                                       style: TextStyle(
                //                                           fontSize: 13),
                //                                     ),
                //                                     SizedBox(
                //                                       height: 10,
                //                                     ),
                //                                     Container(
                //                                       width: 100,
                //                                       height: 100,
                //                                       child: Image.asset(
                //                                         "assets/images/HowtoUse/CloseFar.jpg",
                //                                         fit: BoxFit.cover,
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                               Container(
                //                                 width: 150,
                //                                 child: Column(
                //                                   children: [
                //                                     Text(
                //                                       textAlign:
                //                                           TextAlign.center,
                //                                       "4.พื้นที่มีแสงเพียงพอ",
                //                                       style: TextStyle(
                //                                           fontSize: 13),
                //                                     ),
                //                                     SizedBox(
                //                                       height: 10,
                //                                     ),
                //                                     Container(
                //                                       width: 100,
                //                                       height: 100,
                //                                       child: Image.asset(
                //                                         "assets/images/HowtoUse/LightDark.jpg",
                //                                         fit: BoxFit.cover,
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                   // หน้าที่สอง
                //                   Column(
                //                     mainAxisSize: MainAxisSize.min,
                //                     children: [
                //                       const Text(
                //                         "หน้าที่ 2",
                //                         style: TextStyle(
                //                             fontSize: 20,
                //                             fontWeight: FontWeight.bold),
                //                       ),
                //                       SizedBox(height: 20),
                //                       Text(
                //                         "นี่คือหน้าที่ 2 ของ AlertDialog",
                //                         style: TextStyle(fontSize: 16),
                //                       ),
                //                       SizedBox(height: 20),
                //                       ElevatedButton(
                //                         onPressed: () {
                //                           // ทำสิ่งที่ต้องการในหน้าที่ 2
                //                         },
                //                         child: Text(
                //                             "กดเพื่อทำบางอย่างในหน้าที่ 2"),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             SizedBox(height: 20),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: List.generate(2, (index) {
                //                 return Container(
                //                   margin: EdgeInsets.symmetric(horizontal: 4.0),
                //                   width: _currentPage == index ? 12.0 : 8.0,
                //                   height: _currentPage == index ? 12.0 : 8.0,
                //                   decoration: BoxDecoration(
                //                     shape: BoxShape.circle,
                //                     color: _currentPage == index
                //                         ? Colors.green
                //                         : Colors.grey,
                //                   ),
                //                 );
                //               }),
                //             ),
                //           ],
                //         ),
                //       ),
                //       actions: [
                //         TextButton(
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //           child: const Text("ปิด"),
                //         ),
                //       ],
                //     );
                //   },
                // );

                // showDialog(
                //   barrierDismissible: false,
                //   context: context,
                //   builder: (context) {
                //     return Dialog_HowtoUse();
                //   },
                // );

                // String? results = await showDialog(
                //   barrierDismissible: false,
                //   context: context,
                //   builder: (context) {
                //     return Dialog_WN_Gemini(
                //       number: "258.6 g",
                //     );
                //   },
                // );

                // if (results!.isNotEmpty) {
                //   if (results == "") {
                //     debugPrint("ไม่มีน้ำหนักที่ได้มา");
                //   } else {
                //     debugPrint(results);
                //     // useFunctionandresult();
                //     // ทำอะไรต่อกับ results ตามที่ต้องการ
                //   }
                // } else {
                //   debugPrint("น้ำหนักไม่ถูกต้อง");
                //   debugPrint("น้ำหนักที่ได้มา : $results");
                // }
              },
              child: Text('Analyze Image'),
            ),
          )
        ],
      ),
    );
  }
}
