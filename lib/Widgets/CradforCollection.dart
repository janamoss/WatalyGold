import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Home/Collection/SelectResultmuti.dart';
import 'package:watalygold/Home/Collection/Selectcollection.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogCollectionEdit.dart';
import 'package:watalygold/Widgets/DialogDelete.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Result_ana.dart';

class CradforColletion extends StatefulWidget {
  final Collection collections;
  final VoidCallback refreshCallback;
  const CradforColletion(
      {super.key, required this.collections, required this.refreshCallback});

  @override
  State<CradforColletion> createState() => _CradforColletionState();
}

class _CradforColletionState extends State<CradforColletion> {
  List<Result> _resultlist = [];

  Future<void> fetchCountResult(int collection_id) async {
    _resultlist = await Result_DB().fetchCountReinCol(collection_id);
    stdout.writeln(_resultlist.length); // ตรงนี้จะแสดงค่าที่ถูกต้อง
    stdout.writeln("$collection_id ค่าาาา");
    setState(() {}); // เรียกรีเฟรช UI
    widget.refreshCallback;
    return;
  }

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

  void refreshresult() {
    fetchCountResult(widget.collections.collection_id);
    widget.refreshCallback();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCountResult(widget.collections.collection_id);
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCollection(
              collect: widget.collections,
              refreshs: () =>
                  fetchCountResult(widget.collections.collection_id),
            ),
          ),
        );
      },
      child: Card(
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "การวิเคราะห์ : ",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                Text(
                  "${_resultlist.length}",
                  style: TextStyle(
                      fontSize: 13,
                      color: GPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  " รายการ",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
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
                          // _showToast();
                          Navigator.of(context).push(_createRoute());
                        },
                        child: Text(
                          "เพิ่มผลการวิเคราะห์",
                          style: TextStyle(
                              color: Colors.green.shade300,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
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
                            transitionBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                              return DialogCollectionEdit(
                                edit_name: widget.collections.collection_name,
                                edit_image: widget.collections.collection_image,
                                collection_id: widget.collections.collection_id,
                              );
                            },
                          );
                          fetchCountResult(widget.collections.collection_id);
                          widget.refreshCallback();
                        },
                        child: Text(
                          "แก้ไขคอลเลคชัน",
                          style: TextStyle(
                              color: Colors.orange.shade300,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
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
                            transitionBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                          fetchCountResult(widget.collections.collection_id);
                          widget.refreshCallback();
                        },
                        child: Text(
                          "ลบคอลเลคชัน",
                          style: TextStyle(
                              color: Colors.red.shade300,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SelectResult(
        collections: widget.collections,
        refreshs: () => refreshresult(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
