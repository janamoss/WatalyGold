import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogDelete.dart';
import 'package:watalygold/models/Collection.dart';

class CradforColletion extends StatefulWidget {
  final Collection collections;
  final VoidCallback refreshCallback;
  const CradforColletion(
      {super.key, required this.collections, required this.refreshCallback});

  @override
  State<CradforColletion> createState() => _CradforColletionState();
}

class _CradforColletionState extends State<CradforColletion> {
  Future<void> _showToast() async {
    await Fluttertoast.showToast(
      msg: "This is a toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    await Future.delayed(Duration(seconds: 3));
  }

  void DeleteColletion() async {
    Collection_DB().delete(widget.collections.collection_id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // กำหนด radius ของการ์ด
      ),
      surfaceTintColor: WhiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            // width: 120,
            // height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: widget.collections.collection_image ==
                    "assets/images/Collection.png"
                ? Image(
                    image: AssetImage(widget.collections.collection_image
                        .toString()), // ใช้ FileImage
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  )
                : Image(
                    image: FileImage(File(widget.collections.collection_image
                        .toString())), // ใช้ FileImage
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  ),
          ),
          Center(
            child: Text(
              '${widget.collections.collection_name}',
              style: const TextStyle(
                color: GPrimaryColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                surfaceTintColor: WhiteColor,
                elevation: 5,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        _showToast();
                      },
                      child: Text(
                        "เพิ่มผลการวิเคราะห์",
                        style: TextStyle(
                            color: Colors.green.shade300, fontSize: 15),
                      ),
                      value: '',
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: Text(
                        "แก้ไขคอลเลคชัน",
                        style: TextStyle(
                            color: Colors.orange.shade300, fontSize: 15),
                      ),
                      value: '',
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        await showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          transitionDuration: Duration(milliseconds: 500),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final tween = Tween(begin: 0.0, end: 1.0).chain(
                              CurveTween(curve: Curves.bounceOut),
                            );
                            return ScaleTransition(
                              scale: animation.drive(tween),
                              child: child,
                            );
                          },
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return DialogDelete(
                                message: widget.collections.collection_name,
                                name: "คอลเลคชัน",
                                onConfirm: DeleteColletion);
                          },
                        );
                        widget.refreshCallback();
                      },
                      child: Text(
                        "ลบคอลเลคชัน",
                        style:
                            TextStyle(color: Colors.red.shade300, fontSize: 15),
                      ),
                      value: '',
                    )
                  ];
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}



// const Spacer(),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "ระดับ",
                    //       style: TextStyle(color: GPrimaryColor, fontSize: 15),
                    //     ),
                    //     const SizedBox(width: 15), // เว้นระยะห่างระหว่างข้อความ
                    //     Text(
                    //       widget.result,
                    //       style: TextStyle(
                    //           color: gradeColor[widget.result],
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ],
                    // ),
                    // const Spacer(),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "วันที่ ${widget.date}",
                    //       style: TextStyle(
                    //           color: Colors.grey.shade500, fontSize: 12),
                    //     ),
                    //     Spacer(),
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 10),
                    //       child: ElevatedButton(
                    //           style: ButtonStyle(
                    //             backgroundColor: MaterialStateProperty.all(
                    //                 Colors.red.shade400),
                    //             surfaceTintColor: MaterialStateProperty.all(
                    //                 Colors.red.shade400),
                    //             padding: MaterialStateProperty.all(
                    //                 const EdgeInsets.symmetric(
                    //                     horizontal: 10, vertical: 5)),
                    //             minimumSize: MaterialStateProperty.all(
                    //                 const Size(30, 30)),
                    //           ),
                    //           onPressed: () {},
                    //           child: const Icon(
                    //             Icons.delete_rounded,
                    //             color: WhiteColor,
                    //             size: 20,
                    //           )),
                    //     )
                    //   ],
                    // ),
                    // ElevatedButton.icon(
                    //     style: ButtonStyle(
                    //       backgroundColor: MaterialStateProperty.all(
                    //           Colors.green.shade400),
                    //       surfaceTintColor: MaterialStateProperty.all(
                    //           Colors.green.shade400),
                    //       padding: MaterialStateProperty.all(
                    //           const EdgeInsets.symmetric(
                    //               horizontal: 10, vertical: 5)),
                    //       minimumSize: MaterialStateProperty.all(
                    //           const Size(50, 25)),
                    //     ),
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       Icons.collections_rounded,
                    //       color: WhiteColor,
                    //       size: 20,
                    //     ),
                    //     label: const Icon(
                    //       Icons.add,
                    //       color: WhiteColor,
                    //       size: 10,
                    //     )),