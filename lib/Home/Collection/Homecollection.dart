import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/CradforCollection.dart';
import 'package:watalygold/Widgets/DialogCollection.dart';
import 'package:watalygold/models/Collection.dart';

class HomeCollection extends StatefulWidget {
  const HomeCollection({super.key});

  @override
  State<HomeCollection> createState() => _HomeCollectionState();
}

class _HomeCollectionState extends State<HomeCollection> {
  List<Collection> _collection = [];

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _showToast() async {
    await Fluttertoast.showToast(
      msg: "This is a toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // รอ 2 วินาทีก่อนดำเนินการต่อ
    await Future.delayed(Duration(seconds: 3));

    // ทำสิ่งอื่นๆ ต่อ
  }

  Future<void> _loadCollections() async {
    _collection = await Collection_DB().fetchAll();
    print(_collection.length);
    setState(() {});
  }

  void refreshDialogCollection() {
    setState(() {}); // refresh state of DialogCollection
  }

  void refreshList() {
    _loadCollections(); // เรียกใช้ฟังก์ชันนี้เพื่ออัปเดตรายการ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      floatingActionButton: FloatingActionButton(
        splashColor: GPrimaryColor.withOpacity(0.2),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(80)),
        elevation: 3,
        backgroundColor: WhiteColor,
        tooltip: 'Increment',
        onPressed: () async {
          _showToast();
          await showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            transitionDuration: Duration(milliseconds: 500),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
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
          setState(() {});
          _loadCollections();
        },
        child: SvgPicture.asset(
          "assets/images/collections-add-svgrepo-com.svg",
          colorFilter: ColorFilter.mode(GPrimaryColor, BlendMode.srcIn),
          semanticsLabel: 'A red up arrow',
          height: 40,
          width: 40,
        ),
      ),
      //   child: const Icon(Icons.add_to_photos_rounded,
      //       color: GPrimaryColor, size: 30),
      // ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return Column(
                    children: [
                      Center(
                        child: SearchBar(
                          constraints: BoxConstraints(
                            minWidth: 100,
                            minHeight: 45,
                            maxWidth: 300,
                            maxHeight: 60,
                          ),
                          elevation: MaterialStateProperty.all(2),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                          controller: controller,
                          hintText: "ค้นหาคอลเลคชันของคุณ",
                          surfaceTintColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          padding: MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 15)),
                          // onTap: () {
                          //   controller.openView();
                          // },
                          // onChanged: (_) {
                          //   controller.openView();
                          // },
                          leading: Icon(Icons.search),
                        ),
                      ),
                    ],
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // จำนวนคอลัมน์
                    childAspectRatio: 3 / 4, // อัตราส่วน width ต่อ height
                  ),
                  itemCount: _collection.length,
                  itemBuilder: (context, index) {
                    final collection = _collection[index];
                    return SizedBox(
                      child: CradforColletion(
                          collections: collection,
                          refreshCallback: refreshList),
                    );
                  },
                ),
                // ListView.builder(
                //   itemCount: _collection.length,
                //   itemBuilder: (context, index) {
                //     final collection = _collection[index];

                //   },
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
