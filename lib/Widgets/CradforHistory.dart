import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogCollection.dart';
import 'package:watalygold/Widgets/DialogDelete.dart';
import 'package:watalygold/Widgets/DialogLoading.dart';
import 'package:watalygold/Widgets/DialogSuccess.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Result_ana.dart';
import 'package:watalygold/models/Image.dart';

class CradforHistory extends StatefulWidget {
  final String date;
  final Result results;
  final List<Collection>? collection;
  final int? statusdelete;
  final int? number;
  final Map<int, List<Images>>? resultimage;
  final int? statusSelect;
  final VoidCallback refreshCallback;
  final bool? isChecked;
  final VoidCallback? onCheckChanged;
  const CradforHistory({
    super.key,
    required this.date,
    required this.results,
    required this.refreshCallback,
    this.collection,
    this.statusdelete,
    this.number,
    this.resultimage,
    this.statusSelect,
    this.isChecked,
    this.onCheckChanged,
  });

  @override
  State<CradforHistory> createState() => _CradforHistoryState();
}

class _CradforHistoryState extends State<CradforHistory> {
  bool isCheck = false;

  Collection? collections;
  final List<Images> _results = [];
  final ValueNotifier<List<Images>> _imageList = ValueNotifier([]);

  Future<void> fetchImage(int resultId) async {
    _imageList.value = await Image_DB().fetchImageinResult(resultId);
    stdout.writeln(_imageList.value.length);
    return;
  }

  Future<void> _showToastUpdate() async {
    await Fluttertoast.showToast(
        msg: "บันทึกลงคอลเลคชันเรียบร้อย",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green.shade300,
        textColor: WhiteColor,
        fontSize: 15);
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> _dialogloading() async {
    // Show the dialog on a separate thread
    await Future(() async {
      showDialog(
        context: context,
        builder: (context) {
          return DialogLoading();
        },
      );
    });

    // Wait for 1 second on the main thread
    await Future.delayed(Duration(seconds: 1));

    // Dismiss the dialog
    Navigator.pop(context);
  }

  void DeleteResult() async {
    Result_DB().delete(widget.results.result_id);
  }

  void DeleteResultincolletion() async {
    Result_DB().updatecollection(0, widget.results.result_id);
  }

  @override
  Widget build(BuildContext context) {
    fetchImage(int.parse(widget.results.result_id.toString()));
    const Map<String, Color> gradeColor = {
      "ขั้นพิเศษ": Color(0xFF42BD41),
      "ขั้นที่ 1": Color(0xFF86BD41),
      "ขั้นที่ 2": Color(0xFFB6AC55),
      "ไม่เข้าข่าย": Color(0xFFB68955),
    };
    return ValueListenableBuilder(
      valueListenable: _imageList,
      builder: (context, images, child) {
        // final resultId = int.parse(widget.results.result_id.toString());
        // final imagesForResult = widget.resultimage![resultId] ?? [];
        if (images.isNotEmpty) {
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // กำหนด radius ของการ์ด
            ),
            surfaceTintColor: WhiteColor,
            color: WhiteColor,
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
                              widget.number != null
                                  ? Text(
                                      widget.number != null
                                          ? 'รายการที่ ${widget.number}'
                                          : '',
                                      style: const TextStyle(
                                        color: GPrimaryColor,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.start,
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          "ระดับ",
                                          style: TextStyle(
                                              color: GPrimaryColor,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                            width:
                                                15), // เว้นระยะห่างระหว่างข้อความ
                                        Text(
                                          widget.results.quality,
                                          style: TextStyle(
                                              color: gradeColor[
                                                  widget.results.quality],
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                              Spacer(),
                              widget.statusSelect != null
                                  ? IconButton(
                                      onPressed: () {
                                        widget.onCheckChanged!();
                                      },
                                      icon: widget.isChecked!
                                          ? Icon(
                                              Icons.check_circle_rounded,
                                              color: GPrimaryColor,
                                              size: 25,
                                            )
                                          : Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Colors.grey.shade400,
                                              size: 25,
                                            ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                widget.results.collection_id ==
                                                        0
                                                    ? MaterialStateProperty.all(
                                                        Colors.green.shade400)
                                                    : MaterialStateProperty.all(
                                                        Colors.transparent),
                                            surfaceTintColor:
                                                widget.results.collection_id ==
                                                        0
                                                    ? MaterialStateProperty.all(
                                                        Colors.green.shade400)
                                                    : MaterialStateProperty.all(
                                                        Colors.transparent),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5)),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                    const Size(50, 25)),
                                          ),
                                          onPressed: widget
                                                      .results.collection_id ==
                                                  0
                                              ? () {
                                                  _displaybottomsheet(context);
                                                }
                                              : () {
                                                  // _displaybottomsheet(context);
                                                },
                                          icon: Icon(
                                            Icons.collections_rounded,
                                            color:
                                                widget.results.collection_id ==
                                                        0
                                                    ? WhiteColor
                                                    : Colors.grey.shade100,
                                            size: 20,
                                          ),
                                          label: Icon(
                                            widget.results.collection_id == 0
                                                ? Icons.add
                                                : Icons.check,
                                            color:
                                                widget.results.collection_id ==
                                                        0
                                                    ? WhiteColor
                                                    : Colors.grey.shade100,
                                            size: 10,
                                          )),
                                    ),
                            ],
                          ),
                          const Spacer(),
                          widget.number != null
                              ? Row(
                                  children: [
                                    Text(
                                      "ระดับ",
                                      style: TextStyle(
                                          color: GPrimaryColor, fontSize: 15),
                                    ),
                                    const SizedBox(
                                        width:
                                            15), // เว้นระยะห่างระหว่างข้อความ
                                    Text(
                                      widget.results.quality,
                                      style: TextStyle(
                                          color: gradeColor[
                                              widget.results.quality],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : SizedBox(),
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
                                      backgroundColor: MaterialStateProperty.all(
                                          Colors.red.shade400),
                                      surfaceTintColor: MaterialStateProperty.all(
                                          Colors.red.shade400),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5)),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(30, 30)),
                                    ),
                                    onPressed: () async {
                                      final status = widget.statusdelete ?? 0;
                                      if (status == 0) {
                                        debugPrint(
                                            "รายการที่ ${widget.number}");
                                        await showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel:
                                              MaterialLocalizations.of(context)
                                                  .modalBarrierDismissLabel,
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          transitionBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            final tween =
                                                Tween(begin: 0.0, end: 1.0)
                                                    .chain(
                                              CurveTween(
                                                  curve: Curves.bounceOut),
                                            );
                                            return ScaleTransition(
                                              scale: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return DialogDelete(
                                              message: widget.number != null
                                                  ? "รายการที่ ${widget.number}"
                                                  : "รายการที่ ${widget.results.result_id}",
                                              name: "การวิเคราะห์",
                                              onConfirm: DeleteResult,
                                            );
                                          },
                                        );
                                        widget.refreshCallback();

                                        setState(() {});
                                        stdout.writeln('ไม่มีค่า statusdelete');
                                      } else {
                                        await showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel:
                                              MaterialLocalizations.of(context)
                                                  .modalBarrierDismissLabel,
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          transitionBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            final tween =
                                                Tween(begin: 0.0, end: 1.0)
                                                    .chain(
                                              CurveTween(
                                                  curve: Curves.bounceOut),
                                            );
                                            return ScaleTransition(
                                              scale: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return DialogDelete(
                                              message: widget.number != null
                                                  ? "รายการที่ ${widget.number}"
                                                  : "รายการที่ ${widget.results.result_id}",
                                              name: "การวิเคราะห์",
                                              onConfirm:
                                                  DeleteResultincolletion,
                                              statusdelete: 1,
                                            );
                                          },
                                        );
                                        widget.refreshCallback();

                                        setState(() {});
                                      }
                                    },
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
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // กำหนด radius ของการ์ด
            ),
            surfaceTintColor: WhiteColor,
            color: WhiteColor,
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
                                widget.number != null
                                    ? 'รายการที่ ${widget.number}'
                                    : 'รายการที่ ${widget.results.result_id}',
                                style: const TextStyle(
                                  color: GPrimaryColor,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              widget.number == null
                                  ? widget.statusSelect != null
                                      ? IconButton(
                                          onPressed: () {
                                            widget.onCheckChanged!();
                                          },
                                          icon: widget.isChecked!
                                              ? Icon(
                                                  Icons.check_circle_rounded,
                                                  color: GPrimaryColor,
                                                  size: 25,
                                                )
                                              : Icon(
                                                  Icons
                                                      .check_circle_outline_rounded,
                                                  color: Colors.grey.shade400,
                                                  size: 25,
                                                ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: ElevatedButton.icon(
                                              style: ButtonStyle(
                                                backgroundColor: widget.results
                                                            .collection_id ==
                                                        0
                                                    ? MaterialStateProperty.all(
                                                        Colors.green.shade400)
                                                    : MaterialStateProperty.all(
                                                        Colors.transparent),
                                                surfaceTintColor: widget.results
                                                            .collection_id ==
                                                        0
                                                    ? MaterialStateProperty.all(
                                                        Colors.green.shade400)
                                                    : MaterialStateProperty.all(
                                                        Colors.transparent),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10,
                                                            vertical: 5)),
                                                minimumSize:
                                                    MaterialStateProperty.all(
                                                        const Size(50, 25)),
                                              ),
                                              onPressed: widget.results
                                                          .collection_id ==
                                                      0
                                                  ? () {
                                                      _displaybottomsheet(
                                                          context);
                                                    }
                                                  : () {
                                                      // _displaybottomsheet(context);
                                                    },
                                              icon: Icon(
                                                Icons.collections_rounded,
                                                color: widget.results
                                                            .collection_id ==
                                                        0
                                                    ? WhiteColor
                                                    : Colors.grey.shade100,
                                                size: 20,
                                              ),
                                              label: Icon(
                                                widget.results.collection_id ==
                                                        0
                                                    ? Icons.add
                                                    : Icons.check,
                                                color: widget.results
                                                            .collection_id ==
                                                        0
                                                    ? WhiteColor
                                                    : Colors.grey.shade100,
                                                size: 10,
                                              )),
                                        )
                                  : SizedBox(),
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
                                widget.results.quality,
                                style: TextStyle(
                                    color: gradeColor[widget.results.quality],
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
                                      backgroundColor: MaterialStateProperty.all(
                                          Colors.red.shade400),
                                      surfaceTintColor: MaterialStateProperty.all(
                                          Colors.red.shade400),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5)),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(30, 30)),
                                    ),
                                    onPressed: () async {
                                      final status = widget.statusdelete ?? 0;
                                      if (status == 0) {
                                        await showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel:
                                              MaterialLocalizations.of(context)
                                                  .modalBarrierDismissLabel,
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          transitionBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            final tween =
                                                Tween(begin: 0.0, end: 1.0)
                                                    .chain(
                                              CurveTween(
                                                  curve: Curves.bounceOut),
                                            );
                                            return ScaleTransition(
                                              scale: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return DialogDelete(
                                              message:
                                                  "รายการที่ ${widget.results.result_id}",
                                              name: "การวิเคราะห์",
                                              onConfirm: DeleteResult,
                                            );
                                          },
                                        );
                                        widget.refreshCallback();

                                        setState(() {});
                                        stdout.writeln('ไม่มีค่า statusdelete');
                                      } else {
                                        await showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel:
                                              MaterialLocalizations.of(context)
                                                  .modalBarrierDismissLabel,
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          transitionBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            final tween =
                                                Tween(begin: 0.0, end: 1.0)
                                                    .chain(
                                              CurveTween(
                                                  curve: Curves.bounceOut),
                                            );
                                            return ScaleTransition(
                                              scale: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return DialogDelete(
                                              message:
                                                  "${widget.results.result_id}",
                                              name: "การวิเคราะห์",
                                              onConfirm:
                                                  DeleteResultincolletion,
                                              statusdelete: 1,
                                            );
                                          },
                                        );
                                        widget.refreshCallback();

                                        setState(() {});
                                      }
                                    },
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
        }
      },
    );
  }

  Future _displaybottomsheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "บันทึกลงคอลเลคชันของคุณ",
                  style: TextStyle(
                      color: GPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                // Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < widget.collection!.length; i++)
                  ListTile(
                    leading: Icon(
                      Icons.collections_rounded,
                      color: Colors.grey.shade700,
                      size: 30,
                    ),
                    title: Text(
                      widget.collection![i].collection_name,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      // _showToastUpdate();
                      final s = await Result_DB().updatecollection(
                          widget.collection![i].collection_id,
                          widget.results.result_id);
                      // stdout.writeln("$s จ้าาาาาาา");
                      stdout.writeln(widget.collection![i].collection_id);
                      Navigator.pop(context);

                      widget.refreshCallback();
                    },
                  ),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/images/collections-add-svgrepo-com.svg",
                    colorFilter:
                        ColorFilter.mode(Colors.grey.shade700, BlendMode.srcIn),
                    semanticsLabel: 'A red up arrow',
                    height: 30,
                    width: 30,
                  ),
                  title: Text(
                    'สร้างคอลเลคชัน',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    final bool? result = await showGeneralDialog(
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
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return DialogCollection();
                      },
                    );
                    if (result == true) {
                      // Navigator.of(context).pop();
                      dialogsuccess(context);
                    } else {
                      Navigator.pop(context);
                    }
                    widget.refreshCallback();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
