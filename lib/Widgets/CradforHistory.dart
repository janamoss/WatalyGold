import 'dart:io';

import 'package:flutter/material.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/models/Result_ana.dart';
import 'package:watalygold/models/Image.dart';

class CradforHistory extends StatefulWidget {
  final String name;
  final String result;
  final String date;
  final Result? result_id;

  const CradforHistory(
      {super.key,
      required this.name,
      required this.result,
      required this.date,
      this.result_id});

  @override
  State<CradforHistory> createState() => _CradforHistoryState();
}

class _CradforHistoryState extends State<CradforHistory> {
  List<Images> _results = [];
  final ValueNotifier<List<Images>> _imageList = ValueNotifier([]);

  Future<void> fetchImage(int result_id) async {
    _imageList.value = await Image_DB().fetchImageinResult(result_id);
    print(_imageList.value.length);
    return;
  }

  @override
  void initState() {
    super.initState();
    fetchImage(int.parse(widget.name));
  }

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
        if (images.isEmpty) {
          // print(images.first.image_url.toString());
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // กำหนด radius ของการ์ด
            ),
            surfaceTintColor: WhiteColor,
            child: SizedBox(
              // width: 450,
              height: 170,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: images.isEmpty
                        ? Image(
                            image: AssetImage(
                                "assets/images/plain-grey-background-ydlwqztavi78gl24.jpg"), // ใช้ FileImage
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image: FileImage(File(images.first.image_url
                                .toString())), // ใช้ FileImage
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 15, bottom: 15),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'รายการที่ ${widget.name}',
                                style: const TextStyle(
                                  color: GPrimaryColor,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green.shade400),
                                      surfaceTintColor:
                                          MaterialStateProperty.all(
                                              Colors.green.shade400),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5)),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(50, 25)),
                                    ),
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.collections_rounded,
                                      color: WhiteColor,
                                      size: 20,
                                    ),
                                    label: const Icon(
                                      Icons.add,
                                      color: WhiteColor,
                                      size: 10,
                                    )),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "ระดับ",
                                style: TextStyle(
                                    color: GPrimaryColor, fontSize: 15),
                              ),
                              const SizedBox(
                                  width: 15), // เว้นระยะห่างระหว่างข้อความ
                              Text(
                                widget.result,
                                style: TextStyle(
                                    color: gradeColor[widget.result],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "วันที่ ${widget.date}",
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 12),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red.shade400),
                                      surfaceTintColor:
                                          MaterialStateProperty.all(
                                              Colors.red.shade400),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5)),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(30, 30)),
                                    ),
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.delete_rounded,
                                      color: WhiteColor,
                                      size: 20,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
    // return Card(
    //   clipBehavior: Clip.antiAlias,
    //   margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
    //   elevation: 4.0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15.0), // กำหนด radius ของการ์ด
    //   ),
    //   surfaceTintColor: WhiteColor,
    //   child: SizedBox(
    //     // width: 450,
    //     height: 170,
    //     child: Row(
    //       children: [
    //         Container(
    //           margin: const EdgeInsets.all(10),
    //           width: 120,
    //           height: 120,
    //           clipBehavior: Clip.antiAlias,
    //           decoration:
    //               BoxDecoration(borderRadius: BorderRadius.circular(20)),
    //           child: Image.asset(
    //             _results.first.image_url.toString(),
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.only(left: 0, top: 15, bottom: 15),
    //             child: Column(
    //               // mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Text(
    //                       'รายการที่ ${widget.name}',
    //                       style: const TextStyle(
    //                         color: GPrimaryColor,
    //                         fontSize: 15,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                     Spacer(),
    //                     Padding(
    //                       padding: const EdgeInsets.only(right: 10),
    //                       child: ElevatedButton.icon(
    //                           style: ButtonStyle(
    //                             backgroundColor: MaterialStateProperty.all(
    //                                 Colors.green.shade400),
    //                             surfaceTintColor: MaterialStateProperty.all(
    //                                 Colors.green.shade400),
    //                             padding: MaterialStateProperty.all(
    //                                 const EdgeInsets.symmetric(
    //                                     horizontal: 10, vertical: 5)),
    //                             minimumSize: MaterialStateProperty.all(
    //                                 const Size(50, 25)),
    //                           ),
    //                           onPressed: () {},
    //                           icon: const Icon(
    //                             Icons.collections_rounded,
    //                             color: WhiteColor,
    //                             size: 20,
    //                           ),
    //                           label: const Icon(
    //                             Icons.add,
    //                             color: WhiteColor,
    //                             size: 10,
    //                           )),
    //                     ),
    //                   ],
    //                 ),
    //                 const Spacer(),
    //                 Row(
    //                   children: [
    //                     Text(
    //                       "ระดับ",
    //                       style: TextStyle(color: GPrimaryColor, fontSize: 15),
    //                     ),
    //                     const SizedBox(width: 15), // เว้นระยะห่างระหว่างข้อความ
    //                     Text(
    //                       widget.result,
    //                       style: TextStyle(
    //                           color: gradeColor[widget.result],
    //                           fontSize: 20,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                   ],
    //                 ),
    //                 const Spacer(),
    //                 Row(
    //                   children: [
    //                     Text(
    //                       "วันที่ ${widget.date}",
    //                       style: TextStyle(
    //                           color: Colors.grey.shade500, fontSize: 12),
    //                     ),
    //                     Spacer(),
    //                     Padding(
    //                       padding: const EdgeInsets.only(right: 10),
    //                       child: ElevatedButton(
    //                           style: ButtonStyle(
    //                             backgroundColor: MaterialStateProperty.all(
    //                                 Colors.red.shade400),
    //                             surfaceTintColor: MaterialStateProperty.all(
    //                                 Colors.red.shade400),
    //                             padding: MaterialStateProperty.all(
    //                                 const EdgeInsets.symmetric(
    //                                     horizontal: 10, vertical: 5)),
    //                             minimumSize: MaterialStateProperty.all(
    //                                 const Size(30, 30)),
    //                           ),
    //                           onPressed: () {},
    //                           child: const Icon(
    //                             Icons.delete_rounded,
    //                             color: WhiteColor,
    //                             size: 20,
    //                           )),
    //                     )
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
